#!python3
"""
SMTP Controller module for handling email sending.
Matches the functionality of the C++ curl_smtp_exec function.
"""

import smtplib
import ssl
import socket
from typing import Optional
from .Message_Structure import StructuredMessage, create_mime_message, create_raw_message


class SMTPController:
    """Controller class for SMTP operations."""

    @staticmethod
    def send_email(message: StructuredMessage) -> bool:
        """
        Send email using Python's smtplib (equivalent to curl_smtp_exec in C++).
        
        Args:
            message: StructuredMessage containing all email details
            
        Returns:
            bool: True if successful, False otherwise
        """
        try:
            # Parse server address (expecting format like smtp.gmail.com:587)
            server_address = message.server_address
            if "://" in server_address:
                # Remove protocol prefix if present
                server_address = server_address.split("://", 1)[1]

            if ":" in server_address:
                server_host, port_str = server_address.rsplit(":", 1)
                port = int(port_str)
            else:
                server_host = server_address
                port = 587  # Default SMTP port for STARTTLS

            # Create SSL context
            context = ssl.create_default_context()

            # Create SMTP session with proxy support if provided
            if message.proxy_address:
                # Parse proxy address (expecting format like http://proxy:port or socks5://proxy:port)
                proxy_host, proxy_port = SMTPController._parse_proxy_address(message.proxy_address)
                
                # Create connection through proxy
                sock = socket.create_connection((proxy_host, proxy_port))
                server = smtplib.SMTP()
                server.sock = sock
            else:
                # Direct connection
                server = smtplib.SMTP(server_host, port)

            # Enable debugging (equivalent to CURLOPT_VERBOSE in curl)
            server.set_debuglevel(1)

            # Start TLS encryption (equivalent to CURLOPT_USE_SSL in curl)
            server.starttls(context=context)

            # Login
            if message.credentials:
                server.login(message.credentials.username, message.credentials.password)
            else:
                raise ValueError("No credentials provided")

            # Create email message
            email_msg = create_mime_message(message)

            # Send email
            text = email_msg.as_string()
            server.sendmail(message.source_email_address, message.target_email_addresses or [], text)

            # Close connection
            server.quit()

            return True

        except Exception as e:
            print(f"An error has happened: {e}")
            return False

    @staticmethod
    def _parse_proxy_address(proxy_address: str) -> tuple[str, int]:
        """
        Parse proxy address to extract host and port.
        
        Args:
            proxy_address: Proxy address string
            
        Returns:
            tuple: (host, port)
        """
        # Remove protocol prefix if present
        if "://" in proxy_address:
            proxy_address = proxy_address.split("://", 1)[1]

        if ":" in proxy_address:
            host, port_str = proxy_address.rsplit(":", 1)
            port = int(port_str)
        else:
            host = proxy_address
            port = 8080  # Default proxy port

        return host, port