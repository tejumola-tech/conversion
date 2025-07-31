# main.py

import boto3
import os
import time
import traceback
from PyPDF2 import PdfReader
from docx import Document

sqs = boto3.client('sqs')
s3 = boto3.client('s3')

INPUT_BUCKET = os.environ.get("INPUT_BUCKET")
OUTPUT_BUCKET = os.environ.get("OUTPUT_BUCKET")
QUEUE_URL = os.environ.get("QUEUE_URL")

def convert_pdf_to_docx(input_path, output_path):
    reader = PdfReader(input_path)
    document = Document()

    for page in reader.pages:
        text = page.extract_text()
        if text:
            document.add_paragraph(text)

    document.save(output_path)

def process_message(message):
    try:
        s3_info = message['Body']
        print("Received message:", s3_info)
        s3_event = eval(s3_info)  # Optional: replace with json.loads for safer parsing

        s3_record = s3_event['Records'][0]['s3']
        key = s3_record['object']['key']

        local_input = "/tmp/input.pdf"
        local_output = "/tmp/output.docx"

        s3.download_file(INPUT_BUCKET, key, local_input)
        convert_pdf_to_docx(local_input, local_output)

        output_key = key.replace(".pdf", ".docx")
        s3.upload_file(local_output, OUTPUT_BUCKET, output_key)

        print(f"Converted {key} and uploaded {output_key}")
        return True
    except Exception as e:
        print("Error processing message:", e)
        traceback.print_exc()
        return False

def poll_sqs():
    while True:
        print("Polling SQS...")
        response = sqs.receive_message(
            QueueUrl=QUEUE_URL,
            MaxNumberOfMessages=1,
            WaitTimeSeconds=10
        )

        messages = response.get('Messages', [])
        for msg in messages:
            receipt_handle = msg['ReceiptHandle']
            if process_message(msg):
                sqs.delete_message(QueueUrl=QUEUE_URL, ReceiptHandle=receipt_handle)
                print("Message deleted.")
        time.sleep(5)

if __name__ == "__main__":
    poll_sqs()
