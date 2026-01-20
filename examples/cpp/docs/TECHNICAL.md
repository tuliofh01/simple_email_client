# SMTP Client - Technical Documentation

## Overview

This is a cross-platform SMTP email client written in C++ that allows users to send emails through any SMTP server using the libcurl library. The program provides an interactive command-line interface for configuring email parameters and sending messages.

## Architecture

### Core Components

#### 1. Data Structures

```cpp
struct Login_Credentials {
    string username;
    string password;
};

struct Raw_Message {
    string data;
    size_t offset_bytes = 0;
};

struct Structured_Message {
    string proxy_address;
    string server_address;
    Login_Credentials credentials;
    string source_email_address;
    vector<string> target_email_addresses;
    string message_subject;
    string message_text;
    Raw_Message message_raw;
};
```

#### 2. Key Functions

##### `read_callback()` - Stream Data Provider
- **Purpose**: Provides email data to libcurl in chunks during SMTP upload
- **Parameters**: 
  - `target_buffer`: Buffer to fill with data
  - `size`, `nitems`: Buffer size calculation
  - `msg_data`: Pointer to Raw_Message structure
- **Returns**: Number of bytes actually copied
- **Behavior**: 
  - Tracks offset to avoid re-reading data
  - Handles end-of-stream condition
  - Copies data in libcurl-compatible chunks

##### `curl_smtp_exec()` - SMTP Engine
- **Purpose**: Configures and executes the SMTP email sending operation
- **Process**:
  1. Initialize libcurl handle
  2. Configure SMTP server URL and credentials
  3. Set sender and recipient addresses
  4. Configure upload mechanism with callback
  5. Enable SSL/TLS security
  6. Execute the SMTP transaction
  7. Clean up resources

##### `msg_setup()` - User Interface
- **Purpose**: Interactive configuration gathering
- **Collects**:
  - Proxy settings (optional)
  - SMTP server address
  - Authentication credentials
  - Sender email address
  - Multiple recipient addresses
  - Email subject and body
- **Formats**: Raw RFC 5322 compatible email message

#### 3. Data Flow

```
User Input → msg_setup() → Structured_Message → curl_smtp_exec() → SMTP Server
                     ↓
              Raw_Message formatting
                     ↓
              read_callback() ← libcurl streaming
```

### Security Features

- **SSL/TLS Support**: All connections use `CURLUSESSL_ALL`
- **Certificate Verification**: Peer and host verification enabled
- **Authentication**: SMTP AUTH with username/password
- **Verbose Logging**: Detailed SSL handshake information

### Email Format Compliance

The program formats messages according to RFC 5322 (Internet Message Format):

```
From: <sender@example.com>\r\n
To: <recipient1@example.com>, <recipient2@example.com>\r\n
Subject: Email Subject\r\n
\r\n
Email body content here
```

## Error Handling

### Connection Errors
- DNS resolution failures
- Network connectivity issues
- SSL/TLS handshake problems

### Authentication Errors  
- Invalid credentials
- Authentication method not supported

### Message Errors
- Malformed email addresses
- Empty recipient lists
- Invalid message formatting

### Memory Management
- Proper cleanup of libcurl resources
- Freeing of curl_slist structures
- No memory leaks in normal operation

## Platform Compatibility

### Supported Platforms
- **Linux**: GCC/Clang with libcurl-dev
- **Windows**: MSVC/MinGW with libcurl
- **macOS**: Clang with libcurl (Homebrew)

### Dependencies
- **CMake 3.20+**: Build system
- **C++20**: Modern C++ features
- **libcurl 7.0+**: HTTP/SMTP client library
- **OpenSSL**: SSL/TLS support (usually bundled with libcurl)

## Performance Considerations

### Memory Efficiency
- Streaming upload avoids loading entire message into memory
- Chunked data transfer suitable for large attachments
- Minimal memory footprint for typical email messages

### Network Efficiency
- Connection reuse for multiple recipients
- Proper SSL session management
- Timeout handling for slow connections

### Scalability
- Support for multiple recipients in single transaction
- Configurable buffer sizes via libcurl internals
- Thread-safe libcurl usage (potential for future enhancement)

## Extensibility Points

### Future Enhancements
1. **Attachment Support**: MIME multipart encoding
2. **HTML Email**: Alternative content types
3. **Configuration Files**: Non-interactive mode
4. **Batch Processing**: Multiple email campaigns
5. **Queue Management**: Asynchronous sending
6. **Template Engine**: Dynamic email content

### Integration Opportunities
- Database integration for recipient lists
- API integration for web applications
- Logging integration for audit trails
- Monitoring integration for delivery tracking

## License

This project is licensed under the MIT License. See the LICENSE file for the full license text.

### MIT License Summary
- ✅ **Commercial use**: You can use this software in commercial products
- ✅ **Modification**: You can modify the source code
- ✅ **Distribution**: You can distribute and sell copies
- ✅ **Sublicensing**: You can release modified versions under different licenses
- ✅ **Private use**: You can use this software privately

### Requirements
- 📄 **License and copyright notice**: Include the original license and copyright notice
- 📄 **Include license file**: Distribute the LICENSE file with your software

### No Warranty
The software is provided "as is" without any warranty.