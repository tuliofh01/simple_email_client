# Python SMTP Client Setup Guide

This guide will walk you through setting up the Python SMTP client from scratch.

## Prerequisites

### System Requirements
- Python 3.8 or higher
- Internet connection
- Email account with SMTP access

## Installation Steps

### 1. Install Python

#### Windows
1. Download Python from [python.org](https://www.python.org/downloads/)
2. Run the installer
3. Check "Add Python to PATH"
4. Verify installation:
   ```cmd
   python --version
   pip --version
   ```

#### macOS
1. Install Homebrew (if not installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```
2. Install Python:
   ```bash
   brew install python
   ```
3. Verify installation:
   ```bash
   python3 --version
   pip3 --version
   ```

#### Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install python3 python3-pip python3-venv
```

#### Linux (Fedora/RHEL)
```bash
sudo dnf install python3 python3-pip
```

### 2. Set Up Project Directory

```bash
# Create project directory
mkdir python_smtp_client
cd python_smtp_client

# Copy the project files or download them
# You should have: main.py, requirements.txt, README.md
```

### 3. Create Virtual Environment

A virtual environment is **highly recommended** to isolate dependencies.

```bash
# Create virtual environment
python -m venv smtp_env

# Activate on Linux/macOS
source smtp_env/bin/activate

# Activate on Windows
smtp_env\Scripts\activate
```

Your terminal prompt should now show `(smtp_env)` indicating the virtual environment is active.

### 4. Install Dependencies

```bash
# Install required packages
pip install -r requirements.txt

# Verify installation
pip list
```

### 5. Verify Setup

```bash
# Test the Python installation
python --version

# Test the script (will start interactive mode)
python main.py --help
```

## Email Provider Setup

### Gmail Setup

1. **Enable 2-Factor Authentication**
   - Go to [Google Account settings](https://myaccount.google.com/)
   - Security → 2-Step Verification → Enable

2. **Generate App Password**
   - Google Account → Security → App passwords
   - Select "Mail" and your device
   - Copy the 16-character password

3. **Use App Password in SMTP Client**
   - Username: your.email@gmail.com
   - Password: [16-character app password]

### Outlook/Hotmail Setup

1. **Ensure account is active**
2. **Use regular password** (no app password needed)
3. **Server settings**:
   - smtp-mail.outlook.com:587

### Yahoo Mail Setup

1. **Enable 2-Factor Authentication**
   - Yahoo Account → Security → 2-step verification

2. **Generate App Password**
   - Account Info → Account Security → App passwords
   - Generate new app password for "Mail"

3. **Use App Password in SMTP Client**

## Configuration Files

### Environment Variables (Optional)

Create a `.env` file for sensitive configuration:

```bash
# Create .env file
touch .env
```

Add your configuration:
```env
SMTP_SERVER=smtp.gmail.com:587
SMTP_USERNAME=your.email@gmail.com
SMTP_PASSWORD=your-app-password
```

### Git Configuration

Create `.gitignore`:
```gitignore
__pycache__/
*.pyc
*.pyo
*.pyd
.Python
env/
venv/
smtp_env/
.env
*.egg-info/
dist/
build/
```

## Testing Your Setup

### 1. Test SMTP Connection
```bash
python main.py
```

### 2. Test with Different Providers
Try different SMTP servers to ensure compatibility:

- **Gmail**: `smtp.gmail.com:587`
- **Outlook**: `smtp-mail.outlook.com:587`
- **Yahoo**: `smtp.mail.yahoo.com:587`

### 3. Verify Email Receipt
Check your recipient's inbox (and spam folder) for test emails.

## Troubleshooting

### Common Issues

#### "ModuleNotFoundError: No module named 'smtplib'"
- **Solution**: Ensure you're using Python 3.8+ with standard library

#### "SSL: WRONG_VERSION_NUMBER"
- **Solution**: Check port settings (587 for STARTTLS, 465 for SSL)

#### "Authentication failed"
- **Solution**: Use App Password for Gmail/Yahoo, check credentials

#### "Connection refused"
- **Solution**: Check firewall settings, try different port

### Debug Mode

Enable verbose output in the script:
- The script automatically enables SMTP debug mode
- You'll see detailed conversation with the SMTP server

## Advanced Setup

### Development Environment

For development, install additional tools:

```bash
# Install development dependencies
pip install black flake8 pytest mypy

# Code formatting
black main.py

# Linting
flake8 main.py

# Type checking
mypy main.py
```

### Docker Setup (Optional)

Create `Dockerfile`:
```dockerfile
FROM python:3.11-slim

WORKDIR /app
COPY requirements.txt .
RUN pip install -r requirements.txt

COPY main.py .
CMD ["python", "main.py"]
```

Build and run:
```bash
docker build -t smtp-client .
docker run -it --rm smtp-client
```

## Next Steps

1. **Read the main README.md** for usage instructions
2. **Configure your email provider** with proper settings
3. **Test with a simple email** to verify everything works
4. **Check the troubleshooting guide** if you encounter issues
5. **Explore automation options** for batch email sending

## Support

If you encounter issues:

1. Check this setup guide first
2. Review the main README.md
3. Check the troubleshooting documentation
4. Verify your email provider settings
5. Test with different SMTP servers

---

**Remember**: Always use App Passwords for services like Gmail and Yahoo. Never use your main account password directly in applications.