#!python3
"""
MIT License

Copyright (c) 2025 SMTP Client Project

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
"""

import sys
import getpass
from src.Message_Structure import StructuredMessage, LoginCredentials, create_raw_message
from src.SMTP_Control import SMTPController


def setup_message() -> StructuredMessage:
    """
    Set up message by collecting user input interactively.
    This is the VIEW layer - handles all user interface.
    Matches the C++ msg_setup() function.
    """
    msg = StructuredMessage()

    # Get proxy address
    msg.proxy_address = input("Type in your proxy address or leave it blank: ").strip()

    # Get SMTP server address
    msg.server_address = input("Type in your SMTP server address: ").strip()

    # Get login credentials
    print("Type in your login credentials below.")
    username = input("Username: ").strip()
    password = getpass.getpass("Password: ")
    msg.credentials = LoginCredentials(username, password)

    # Get sender email
    msg.source_email_address = input("Type in your email address: ").strip()

    # Get recipients
    print("Below, type in your recipients line by line and finish with a blank input.")
    while True:
        recipient = input("Enter a new recipient: ").strip()
        if recipient:
            if msg.target_email_addresses is None:
                msg.target_email_addresses = []
            msg.target_email_addresses.append(recipient)
        else:
            break

    # Get subject
    msg.message_subject = input("Type in your message subject: ").strip()

    # Get message body
    print("Message body, or text (Ctrl+D / Ctrl+Z to finish):")
    lines = []
    try:
        while True:
            line = input()
            lines.append(line)
    except EOFError:
        pass
    msg.message_text = "\n".join(lines)

    # Create raw message (equivalent to C++ raw_content creation)
    raw_content = create_raw_message(msg)
    from src.Message_Structure import RawMessage
    msg.message_raw = RawMessage(raw_content)

    return msg


def main():
    """
    Main function - MVC View layer.
    Orchestrates the user interaction and calls controller.
    """
    try:
        # Set up message interactively (VIEW)
        message = setup_message()

        # Send email using controller (CONTROLLER)
        success = SMTPController.send_email(message)

        # Display result (VIEW)
        if success:
            print("Email sent successfully!")
        else:
            print("Failed to send email.")

        # Exit with appropriate code
        sys.exit(0 if success else 1)

    except KeyboardInterrupt:
        print("\nOperation cancelled by user.")
        sys.exit(1)
    except Exception as e:
        print(f"Unexpected error: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()