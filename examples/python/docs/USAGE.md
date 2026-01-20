# Usage Examples and Documentation

This guide provides detailed usage examples and advanced configurations for the Python SMTP client.

## Basic Usage

### Interactive Mode
The simplest way to use the SMTP client:

```bash
python main.py
```

Follow the prompts:
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

## Email Provider Examples

### Gmail Configuration

**Required Settings:**
- **Server**: `smtp.gmail.com:587`
- **Username**: Your full Gmail address
- **Password**: App Password (16 characters)

**Steps:**
1. Enable 2-Factor Authentication
2. Generate App Password from Google Account settings
3. Use the App Password (not your regular password)

```
Type in your SMTP server address: smtp.gmail.com:587
Username: your.email@gmail.com
Password: [16-character app password]
```

### Outlook/Hotmail Configuration

**Required Settings:**
- **Server**: `smtp-mail.outlook.com:587`
- **Username**: Your Outlook email address
- **Password**: Your regular Outlook password

```
Type in your SMTP server address: smtp-mail.outlook.com:587
Username: your.email@outlook.com
Password: your-regular-password
```

### Yahoo Mail Configuration

**Required Settings:**
- **Server**: `smtp.mail.yahoo.com:587`
- **Username**: Your Yahoo email address
- **Password**: App Password

**Steps:**
1. Enable 2-Factor Authentication
2. Generate App Password from Yahoo Account security
3. Use the App Password

```
Type in your SMTP server address: smtp.mail.yahoo.com:587
Username: your.email@yahoo.com
Password: [Yahoo app password]
```

### Corporate Email Configuration

**Common Corporate SMTP Settings:**
- **Server**: `mail.company.com:587` or `smtp.company.com:587`
- **Username**: Your corporate email address
- **Password**: Your corporate password

**With Proxy:**
```
Type in your proxy address or leave it blank: http://proxy.company.com:8080
Type in your SMTP server address: mail.company.com:587
Username: your.name@company.com
Password: your-corporate-password
```

## Advanced Usage Examples

### Sending to Multiple Recipients

```
Enter a new recipient: team@company.com
Enter a new recipient: manager@company.com
Enter a new recipient: colleague1@company.com
Enter a new recipient: colleague2@company.com
Enter a new recipient: 
```

### Email with Different Subjects

**Professional Email:**
```
Type in your message subject: Project Update - Q1 2025 Progress
```

**Personal Email:**
```
Type in your message subject: Weekend Meeting Confirmation
```

**Notification Email:**
```
Type in your message subject: System Maintenance Scheduled
```

### Message Body Examples

**Simple Text Email:**
```
Hi Team,

Just wanted to update you on the project progress.

We have completed:
- Initial setup
- Database configuration
- API development

Next steps:
- Testing phase
- Documentation
- Deployment preparation

Best regards,
John
```

**Formal Business Email:**
```
Dear [Recipient Name],

I hope this email finds you well.

I am writing to inform you about the upcoming system maintenance scheduled for this weekend. The maintenance window will be from Saturday 2:00 AM to Sunday 6:00 AM EST.

During this time:
- All services will be temporarily unavailable
- Data will be backed up
- System updates will be applied

We apologize for any inconvenience this may cause. If you have any questions or concerns, please don't hesitate to contact our support team.

Thank you for your understanding.

Best regards,
[Your Name]
[Your Position]
[Your Company]
```

## Message Format Examples

### Email with Different Recipients

**To Team Members:**
```
To: alice@company.com, bob@company.com, charlie@company.com
Subject: Team Meeting Tomorrow at 2 PM

Hi everyone,

Reminder about our team meeting tomorrow at 2 PM in Conference Room B.

Agenda:
1. Project status update
2. Q2 planning
3. Resource allocation

Please come prepared with your project updates.

Thanks,
[Your Name]
```

**To Management:**
```
To: manager@company.com, director@company.com
Subject: Monthly Performance Report - January 2025

Dear Management,

Please find below the key performance metrics for January 2025:

- Project completion rate: 95%
- Customer satisfaction: 4.8/5.0
- Team productivity: +15% vs. last month

Detailed reports are attached to this email.

Best regards,
[Your Name]
[Your Position]
```

## Special Use Cases

### Sending Through Proxy

**Corporate Proxy Configuration:**
```
Type in your proxy address or leave it blank: http://proxy.company.com:8080
```

**SOCKS Proxy:**
```
Type in your proxy address or leave it blank: socks5://proxy.company.com:1080
```

### Testing Different SMTP Ports

**Port 25 (Unencrypted - Not Recommended):**
```
Type in your SMTP server address: smtp.test.com:25
```

**Port 587 (STARTTLS - Recommended):**
```
Type in your SMTP server address: smtp.test.com:587
```

**Port 465 (SSL/TLS):**
```
Type in your SMTP server address: smtp.test.com:465
```

## Debugging and Troubleshooting

### Verbose Output

The script automatically enables verbose SMTP logging. You'll see detailed output like:

```
send: 'ehlo [localhost]\r\n'
reply: b'250-smtp.gmail.com at your service, [192.168.1.1]\r\n'
reply: b'250-SIZE 35882577\r\n'
reply: b'250-8BITMIME\r\n'
reply: b'250-STARTTLS\r\n'
reply: b'250-ENHANCEDSTATUSCODES\r\n'
reply: b'250-PIPELINING\r\n'
reply: b'250 SMTPUTF8\r\n'
reply: retcode (250); Msg: b'smtp.gmail.com at your service, [192.168.1.1]'
send: 'STARTTLS\r\n'
reply: b'220 2.0.0 Ready to start TLS\r\n'
```

### Common Error Scenarios

**Authentication Error:**
```
An error has happened: (535, b'5.7.8 Username and Password not accepted')
```
**Solution**: Check credentials, use App Password for Gmail/Yahoo

**Connection Error:**
```
An error has happened: [Errno 61] Connection refused
```
**Solution**: Check server address and port, firewall settings

**SSL Error:**
```
An error has happened: [SSL: WRONG_VERSION_NUMBER] wrong version number (_ssl.c:1108)
```
**Solution**: Use correct port (587 for STARTTLS, 465 for SSL)

## Best Practices

### Security
1. **Always use App Passwords** for Gmail/Yahoo
2. **Never share credentials** in code or documentation
3. **Use STARTTLS or SSL** connections
4. **Consider environment variables** for automated scripts

### Email Content
1. **Clear subject lines** for better organization
2. **Professional greeting** and closing
3. **Proper formatting** with line breaks
4. **Proofread** before sending

### Performance
1. **Batch multiple recipients** when possible
2. **Use appropriate connection timeout**
3. **Handle network errors gracefully**
4. **Log errors for debugging**

## Script Automation (Advanced)

While the current script is interactive, you can modify it for automation:

```python
# Example of how to automate (not in current script)
message = StructuredMessage()
message.server_address = "smtp.gmail.com:587"
message.credentials = LoginCredentials("email@gmail.com", "app_password")
message.source_email_address = "email@gmail.com"
message.target_email_addresses = ["recipient@example.com"]
message.message_subject = "Automated Email"
message.message_text = "This is an automated email."
```

## Template Examples

### Meeting Invitation
```
Subject: Meeting Invitation: [Topic] on [Date]

Dear [Recipient],

You are invited to a meeting to discuss [Topic].

Date: [Date]
Time: [Time]
Location: [Location/Video Conference Link]

Agenda:
1. [Agenda Item 1]
2. [Agenda Item 2]
3. [Agenda Item 3]

Please confirm your attendance.

Best regards,
[Your Name]
```

### Project Update
```
Subject: Project [Name] Update - [Date]

Hi Team,

Here's the weekly update for Project [Name]:

✅ Completed This Week:
- [Task 1]
- [Task 2]

🔄 In Progress:
- [Task 3]
- [Task 4]

📅 Next Week:
- [Task 5]
- [Task 6]

📊 Metrics:
- Progress: [X]%
- Budget: $[X]/$[Y]
- Timeline: On track/At risk/Delayed

Questions or concerns? Let me know.

Best,
[Your Name]
```

---

For more examples and troubleshooting, check out the [Setup Guide](SETUP.md) and the main README.md file.