# SMTP Client - Python Version

A cross-platform command-line SMTP email client written in Python. Send emails through any SMTP server with interactive configuration. This is the Python equivalent of the C++ implementation.

## Features

- 🌍 **Cross-platform**: Linux, Windows, macOS support
- 🔒 **Secure**: SSL/TLS encryption with certificate verification
- 📧 **SMTP compliant**: Full RFC 5322 email format support  
- 🎯 **Easy to use**: Interactive command-line interface
- 📦 **Lightweight**: Minimal dependencies, uses Python standard library
- 🐍 **Modern Python**: Python 3.8+ with type hints
- 🔐 **Secure input**: Password masking for credentials

## Quick Start

### Prerequisites
- Python 3.8 or higher
- pip (Python package manager)

### Setup

#### 1. Clone or Download the Project
```bash
# If you have the full repository
cd smtp_client/examples/python

# Or download just the Python files and place them in a directory
```

#### 2. Create Virtual Environment (Recommended)
```bash
# Create virtual environment
python -m venv smtp_env

# Activate on Linux/macOS
source smtp_env/bin/activate

# Activate on Windows
smtp_env\Scripts\activate
```

#### 3. Install Dependencies
```bash
# Install required packages
pip install -r requirements.txt

# For development (optional)
pip install -r requirements-dev.txt
```

#### 4. Run the Client
```bash
python main.py
```

## Usage

### Interactive Mode
Run the program and follow the prompts:

```
Type in your proxy address or leave it blank: 
Type in your SMTP server address: smtp.gmail.com:587
Type in your login credentials below.
Username: your.email@gmail.com
Password: [Your App Password]
Type in your email address: your.email@gmail.com
Below, type in your recipients line by line and finish with a blank input.
Enter a new recipient: recipient1@example.com
Enter a new recipient: recipient2@example.com
Enter a new recipient: 
Type in your message subject: Test Email
Message body, or text (Ctrl+D / Ctrl+Z to finish):
This is a test email sent using the Python SMTP client.

Best regards,
Your Name
^D
```

### SMTP Server Examples

#### Gmail
```
SMTP Server: smtp.gmail.com:587
Username: your.email@gmail.com
Password: [App Password - generate from Google Account settings]
```

#### Outlook/Hotmail
```
SMTP Server: smtp-mail.outlook.com:587
Username: your.email@outlook.com
Password: your.password
```

#### Yahoo Mail
```
SMTP Server: smtp.mail.yahoo.com:587
Username: your.email@yahoo.com
Password: [App Password - generate from Yahoo Account security]
```

#### Generic SMTP Server
```
SMTP Server: your-server.com:25  (for unencrypted)
SMTP Server: your-server.com:587 (for STARTTLS)
SMTP Server: your-server.com:465 (for SSL/TLS)
Username: your.username
Password: your.password
```

## Python Project Setup Guide

### For New Users: Setting Up a Python Project

#### 1. Install Python
- **Windows**: Download from [python.org](https://python.org)
- **macOS**: `brew install python` or download from python.org
- **Linux**: `sudo apt install python3 python3-pip` (Ubuntu/Debian)

#### 2. Verify Installation
```bash
python --version
pip --version
```

#### 3. Virtual Environment Best Practices
```bash
# Create project directory
mkdir my_smtp_project
cd my_smtp_project

# Create virtual environment
python -m venv venv

# Activate environment
# Linux/macOS:
source venv/bin/activate
# Windows:
venv\Scripts\activate

# Your prompt should now show (venv)
```

#### 4. Project Structure
```
my_smtp_project/
├── venv/                 # Virtual environment
├── main.py              # Main script
├── requirements.txt     # Dependencies
├── README.md           # Documentation
└── .gitignore          # Git ignore file
```

#### 5. Common Python Commands
```bash
# Install packages
pip install package_name

# Save requirements
pip freeze > requirements.txt

# Install from requirements
pip install -r requirements.txt

# Run Python script
python main.py

# Deactivate virtual environment
deactivate
```

## Configuration

### Security Settings
- **SSL/TLS**: Always enabled with certificate verification
- **Authentication**: SMTP AUTH with username/password
- **Connection**: Secure STARTTLS or SSL/TLS connections
- **Password Input**: Uses getpass to hide password input

### Supported Features
- Multiple recipients in single send
- Plain text email body
- Custom headers (via message formatting)
- Proxy support ( configurable )
- Verbose logging for troubleshooting
- Secure password input

## Development

### Project Structure
```
examples/python/
├── main.py              # Main application code
├── requirements.txt     # Production dependencies
├── pyproject.toml      # Project configuration
├── README.md           # This file
└── docs/               # Additional documentation
    ├── SETUP.md        # Setup guide
    ├── USAGE.md        # Usage examples
    └── TROUBLESHOOTING.md  # Troubleshooting guide
```

### Dependencies
- **Python Standard Library**: smtplib, ssl, email, typing, getpass, sys
- **No external dependencies required** for basic functionality

### Code Style
- Type hints for better code documentation
- PEP 8 compliant
- Object-oriented design with clear separation of concerns
- Comprehensive error handling

### Testing (Optional)
```bash
# Install test dependencies
pip install pytest pytest-cov

# Run tests
pytest

# Run with coverage
pytest --cov=.
```

## Error Messages and Solutions

### "An error has happened: [SSL: WRONG_VERSION_NUMBER] wrong version number"
**Cause**: Port mismatch or SSL configuration issue  
**Solution**: 
- Use port 587 for STARTTLS
- Use port 465 for SSL/TLS
- Check your email provider's SMTP settings

### "An error has happened: Authentication failed"
**Cause**: Invalid credentials or authentication method  
**Solution**: 
- Check username/password
- For Gmail/Yahoo, use App Password instead of account password
- Verify SMTP server supports your authentication method

### "An error has happened: Connection refused"
**Cause**: Network connectivity or firewall issues  
**Solutions**:
- Check internet connection
- Verify firewall allows outbound SMTP (ports 25, 587, 465)
- Try with proxy if required

### "An error has happened: Certificate verify failed"
**Cause**: SSL certificate verification failure  
**Solutions**:
- For testing only, you might need to configure certificate bundle
- Contact your email provider for proper certificate settings

## Security Notes

- **Never hardcode credentials** in source code
- **Use App Passwords** for services like Gmail/Yahoo
- **Store credentials securely** when automating
- **Verify SSL certificates** - don't disable verification in production
- **Use environment variables** for sensitive configuration
- **Password masking**: The application uses getpass to hide password input

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## License

This project is licensed under the MIT License. See the [LICENSE](../../../LICENSE) file for details.

## Disclaimer

Please ensure compliance with your email provider's terms of service when using this SMTP client.

## Support

For issues and questions:
1. Check the [Technical Documentation](docs/TECHNICAL.md)
2. Review the [Setup Guide](docs/SETUP.md)
3. Verify your SMTP server configuration
4. Test with different credentials or servers

---

**Disclaimer**: This tool is for legitimate email sending only. Ensure you have permission to send emails through the configured SMTP server and comply with all applicable laws and regulations.