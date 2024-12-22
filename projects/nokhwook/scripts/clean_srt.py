import re
import sys

from pathlib import Path


def clean_srt_content(content):
    # Remove extraneous characters and tags
    content = re.sub(r"<[^>]+>", "", content)  # Remove HTML tags
    content = re.sub(r"\{[^}]+\}", "", content)  # Remove subtitle formatting tags
    content = re.sub(r"\[.*?\]", "", content)  # Remove text inside square brackets
    content = re.sub(r"\(.*?\)", "", content)  # Remove text inside parentheses
    content = re.sub(
        r'[^a-zA-Z0-9äöüßÄÖÜàáâãèéêìíòóôõùúýăđĩũơưăâêôơưก-๙\s\n.,?!\'"->:]', "", content
    )  # Remove non-alphanumeric characters except punctuation
    return content


def clean_srt_file(file_path):
    # Open the file and read its content
    with open(file_path, "r", encoding="utf-8") as file:
        content = file.read()

    # Clean the content
    cleaned_content = clean_srt_content(content)

    # Construct the name of the output file
    input_file_path = Path(file_path)
    output_file_path = f"{input_file_path.stem}.cleaned{input_file_path.suffix}"

    # Write the cleaned content to the output file
    with open(output_file_path, "w", encoding="utf-8") as file:
        file.write(cleaned_content)

    return output_file_path


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python clean_srt.py <file1.srt> <file2.srt> ...")
        sys.exit(1)

    for file_path in sys.argv[1:]:
        output_file_path = clean_srt_file(file_path)
        print(f"Cleaned {file_path} --> {output_file_path}")
