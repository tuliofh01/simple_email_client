#!python3
"""
Email message data structures for the SMTP client.
Follows the structure from the C++ implementation.
"""

from dataclasses import dataclass
from typing import List, Optional
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.utils import formataddr


@dataclass
class LoginCredentials:
    """User credentials for SMTP authentication."""
    username: str
    password: str


@dataclass
class RawMessage:
    """Raw email message data for sending."""
    data: str
    offset_bytes: int = 0


@dataclass
class StructuredMessage:
    """Complete email message structure matching C++ implementation."""
    proxy_address: str = ""
    server_address: str = ""
    credentials: Optional[LoginCredentials] = None
    source_email_address: str = ""
    target_email_addresses: List[str] | None = None
    message_subject: str = ""
    message_text: str = ""
    message_raw: Optional[RawMessage] = None

    def __post_init__(self):
        if self.target_email_addresses is None:
            self.target_email_addresses = []


def create_mime_message(message: StructuredMessage) -> MIMEMultipart:
    """Create MIME message from StructuredMessage."""
    email_msg = MIMEMultipart()
    email_msg["From"] = formataddr((message.source_email_address, message.source_email_address))
    email_msg["To"] = ", ".join(message.target_email_addresses or [])
    email_msg["Subject"] = message.message_subject

    # Attach body
    body = MIMEText(message.message_text, "plain")
    email_msg.attach(body)

    return email_msg


def create_raw_message(message: StructuredMessage) -> str:
    """Create raw email message string following C++ format."""
    recipients = ", ".join(message.target_email_addresses or [])
    raw_content = (
        f"From: <{message.source_email_address}>\r\n"
        f"To: <{recipients}>\r\n"
        f"Subject: {message.message_subject}\r\n"
        f"\r\n"
        f"{message.message_text}"
    )
    return raw_content