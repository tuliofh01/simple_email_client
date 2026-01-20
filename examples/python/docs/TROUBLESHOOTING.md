# Troubleshooting Guide

This guide covers common issues and solutions for the Python SMTP client.

## Connection Issues

### "Connection refused" or "Connection timed out"

**Possible Causes:**
- Wrong server address or port
- Firewall blocking SMTP connections
- Network connectivity issues
- SMTP server down

**Solutions:**

1. **Check Server Address and Port:**
   ```
   # Correct format examples:
   smtp.gmail.com:587      # STARTTLS
   smtp.gmail.com:465      # SSL/TLS
   smtp.gmail.com:25       # Unencrypted (not recommended)
   ```

2. **Test Network Connectivity:**
   ```bash
   # Test if server is reachable
   ping smtp.gmail.com
   
   # Test SMTP port
   telnet smtp.gmail.com 587
   ```

3. **Check Firewall Settings:**
   - Ensure outbound SMTP ports (25, 587, 465) are open
   - Check corporate firewall policies
   - Try with proxy if required

4. **Try Different Ports:**
   - Port 587: STARTTLS (recommended)
   - Port 465: SSL/TLS
   - Port 25: Unencrypted (avoid if possible)

### "SSL: WRONG_VERSION_NUMBER"

**Cause**: Port mismatch or SSL configuration issue

**Solutions:**
1. **Use port 587 for STARTTLS** (most common)
   ```
   Server: smtp.gmail.com:587
   ```

2. **Use port 465 for SSL/TLS**
   ```
   Server: smtp.gmail.com:465
   ```

3. **Avoid port 25 for secure connections**

### "Certificate verify failed"

**Cause**: SSL certificate verification issues

**Solutions:**

1. **Check System Time:**
   ```bash
   # Ensure system time is correct
   date
   ```

2. **Update Certificate Bundle** (Linux):
   ```bash
   # Ubuntu/Debian
   sudo apt update && sudo apt install ca-certificates
   
   # CentOS/RHEL
   sudo yum update ca-certificates
   ```

3. **For Testing Only** (not recommended for production):
   ```python
   # This would require modifying the script - not recommended
   # ssl.create_default_context() -> ssl._create_unverified_context()
   ```

## Authentication Issues

### "Authentication failed" or "Login denied"

**Common Causes:**
- Wrong username or password
- Using main password instead of App Password
- Account locked or disabled
- 2FA requirements

**Solutions:**

1. **Gmail Users - Use App Password:**
   - Enable 2-Factor Authentication
   - Go to Google Account → Security → App passwords
   - Generate new App Password for "Mail"
   - Use the 16-character App Password

2. **Yahoo Users - Use App Password:**
   - Enable 2-Factor Authentication
   - Go to Yahoo Account Security → App passwords
   - Generate new App Password
   - Use the App Password, not your main password

3. **Check Username Format:**
   ```
   # Correct:
   username: your.email@gmail.com
   
   # Incorrect:
   username: your.email
   ```

4. **Verify Account Status:**
   - Check if account is locked
   - Look for security alerts
   - Ensure less secure apps are enabled (if required)

### "5.7.8 Username and Password not accepted"

**Gmail Specific Solutions:**
1. **Enable 2-Factor Authentication**
2. **Generate App Password** (don't use regular password)
3. **Check "Less secure app access"** (not recommended, use App Password instead)

**Yahoo Specific Solutions:**
1. **Enable 2-Factor Authentication**
2. **Generate App Password** from Account Security
3. **Check account notifications**

## Email Delivery Issues

### Email not received by recipients

**Possible Causes:**
- Email sent to spam folder
- Recipient email address incorrect
- SMTP server limitations
- Content triggering spam filters

**Solutions:**

1. **Check Spam/Junk Folders:**
   - Ask recipients to check spam folders
   - Verify email headers if possible

2. **Verify Email Addresses:**
   ```
   # Correct formats:
   user@example.com
   user.name@company.co.uk
   
   # Common mistakes:
   user@examplecom     (missing dot)
   user@.example.com   (extra dot)
   ```

3. **Test with Different Recipients:**
   - Send to your own email address first
   - Try different email providers (Gmail, Outlook, etc.)

4. **Check Email Content:**
   - Avoid spam trigger words
   - Use proper subject lines
   - Include proper formatting

## Script and Environment Issues

### "ModuleNotFoundError: No module named 'smtplib'"

**Cause**: Using wrong Python version or broken installation

**Solutions:**

1. **Check Python Version:**
   ```bash
   python --version
   # Should be Python 3.8 or higher
   ```

2. **Verify Python Installation:**
   ```bash
   # Test smtplib import
   python -c "import smtplib; print('smtplib works')"
   ```

3. **Reinstall Python** (if broken):
   ```bash
   # Ubuntu/Debian
   sudo apt install --reinstall python3
   
   # macOS (with Homebrew)
   brew reinstall python
   ```

### Virtual Environment Issues

**Issues:**
- Dependencies not installed in venv
- Wrong Python interpreter
- Activation problems

**Solutions:**

1. **Verify Virtual Environment:**
   ```bash
   # Check if venv is active
   which python
   # Should show path to your venv
   
   # Check installed packages
   pip list
   ```

2. **Recreate Virtual Environment:**
   ```bash
   # Remove old venv
   rm -rf smtp_env
   
   # Create new venv
   python -m venv smtp_env
   
   # Activate and install
   source smtp_env/bin/activate  # Linux/macOS
   pip install -r requirements.txt
   ```

### Permission Issues

**"Permission denied" errors**

**Solutions:**

1. **Check File Permissions:**
   ```bash
   ls -la main.py
   # Should be readable and executable
   ```

2. **Fix Permissions:**
   ```bash
   chmod +x main.py
   chmod 644 main.py
   ```

3. **Run with Appropriate User:**
   ```bash
   # Don't use sudo unless necessary
   python main.py
   ```

## Debugging Tips

### Enable Verbose Logging

The script automatically enables SMTP debug mode. You'll see output like:

```
send: 'ehlo [localhost]\r\n'
reply: b'250-smtp.gmail.com at your service, [192.168.1.1]\r\n'
reply: b'250-SIZE 35882577\r\n'
reply: b'250-8BITMIME\r\n'
reply: b'250-STARTTLS\r\n'
```

### Test SMTP Connection Manually

You can test SMTP connection manually using telnet:

```bash
# Test SMTP connection
telnet smtp.gmail.com 587

# You should see something like:
# 220 smtp.gmail.com ESMTP ...
```

### Check Email Headers

For debugging, you can modify the script to print the raw email message:

```python
# Add this line in send_email() function before server.sendmail()
print("Email content:")
print(text)
```

## Platform-Specific Issues

### Windows Issues

**"WinError 10060: Connection timed out"**

**Solutions:**
1. Check Windows Firewall settings
2. Disable VPN if not needed
3. Check antivirus firewall settings
4. Try different SMTP ports

### macOS Issues

**"SSL: CERTIFICATE_VERIFY_FAILED"**

**Solutions:**
1. Install certificates:
   ```bash
   # Install certificates for Python from python.org
   # Run this script after installing Python
   /Applications/Python\ 3.11/Install\ Certificates.command
   ```

2. Update certificate bundle:
   ```bash
   brew update && brew upgrade
   ```

### Linux Issues

**"Network is unreachable"**

**Solutions:**
1. Check network configuration:
   ```bash
   ip route show
   ping 8.8.8.8
   ```

2. Check DNS resolution:
   ```bash
   nslookup smtp.gmail.com
   dig smtp.gmail.com
   ```

3. Check firewall:
   ```bash
   sudo ufw status
   sudo iptables -L
   ```

## Getting Help

### Information to Collect

When seeking help, provide:

1. **Error Message**: Complete error traceback
2. **SMTP Server**: Which server and port you're using
3. **Email Provider**: Gmail, Outlook, Yahoo, corporate, etc.
4. **Platform**: Windows, macOS, Linux
5. **Python Version**: `python --version`
6. **Network Environment**: Home, corporate, VPN

### Debug Commands

Run these commands to collect debug information:

```bash
# Python version
python --version

# Test network connectivity
ping smtp.gmail.com

# Test SMTP port
telnet smtp.gmail.com 587

# Check DNS resolution
nslookup smtp.gmail.com

# Test smtplib import
python -c "import smtplib; print('smtplib version:', smtplib.__version__)"
```

### Common Debug Scenarios

**Scenario 1: Gmail Authentication**
```bash
# Check if you can login to Gmail web interface
# Verify 2FA is enabled
# Generate new App Password
```

**Scenario 2: Corporate Network**
```bash
# Check if proxy is required
# Test with different ports
# Consult IT department
```

**Scenario 3: SSL Certificate Issues**
```bash
# Update system certificates
# Check system time
# Test with different SMTP servers
```

---

If you continue to experience issues after trying these solutions, please:

1. Check the [Setup Guide](SETUP.md) for configuration help
2. Review [Usage Examples](USAGE.md) for proper formatting
3. Collect debug information as shown above
4. Verify your email provider's SMTP settings

Remember: This tool uses your email credentials securely, but always follow security best practices and use App Passwords when available.