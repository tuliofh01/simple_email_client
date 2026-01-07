# SMTP Client

A cross-platform command-line SMTP email client written in C++ using libcurl. Send emails through any SMTP server with interactive configuration.

## Features

- 🌍 **Cross-platform**: Linux, Windows, macOS support
- 🔒 **Secure**: SSL/TLS encryption with certificate verification
- 📧 **SMTP compliant**: Full RFC 5322 email format support  
- 🎯 **Easy to use**: Interactive command-line interface
- 📦 **Lightweight**: Minimal dependencies, fast execution
- 🔧 **Modern C++**: C++20 with modern standards compliance

## Quick Start

### Prerequisites
- CMake 3.20+
- C++20 compatible compiler
- libcurl development library

### Build (Linux/macOS)
```bash
# Install dependencies
sudo apt install build-essential cmake libcurl4-openssl-dev  # Ubuntu/Debian
# OR
sudo dnf install cmake gcc-c++ libcurl-devel openssl-devel  # Fedora/RHEL

# Build
cd smtp_client/examples/cpp
mkdir build && cd build
cmake ..
make -j$(nproc)

# Run
./send_mail
```

### Build (Windows)
```cmd
# Using vcpkg (recommended)
git clone https://github.com/Microsoft/vcpkg.git
cd vcpkg
.\bootstrap-vcpkg.bat
.\vcpkg integrate install
.\vcpkg install curl[openssl]:x64-windows

# Build
cd path\to\smtp_client\examples\cpp
mkdir build && cd build
cmake .. -DCMAKE_TOOLCHAIN_FILE=C:\vcpkg\scripts\buildsystems\vcpkg.cmake -A x64
cmake --build . --config Release

# Run
.\Release\send_mail.exe
```

## Usage

### Interactive Mode
Run the program and follow the prompts:

```
Type in your proxy address or leave it blank: 
Type in your SMTP server address: smtp://smtp.gmail.com:587
Type in your login credentials bellow.
Username: your.email@gmail.com
Password: your-app-password
Type in your email address: your.email@gmail.com
Bellow, type in your recipients line by line and finish with a blank input.
Enter a new recipient: recipient1@example.com
Enter a new recipient: recipient2@example.com
Enter a new recipient: 
Type in your message subject: Test Email
Message body, or text (Ctrl+D / Ctrl+Z to finish):
This is a test email sent using the SMTP client.

Best regards,
Your Name
^D
```

### SMTP Server Examples

#### Gmail
```
SMTP Server: smtp://smtp.gmail.com:587
Username: your.email@gmail.com
Password: [App Password - generate from Google Account settings]
```

#### Outlook/Hotmail
```
SMTP Server: smtp://smtp-mail.outlook.com:587
Username: your.email@outlook.com
Password: your.password
```

#### Yahoo Mail
```
SMTP Server: smtp://smtp.mail.yahoo.com:587
Username: your.email@yahoo.com
Password: [App Password - generate from Yahoo Account security]
```

#### Generic SMTP Server
```
SMTP Server: smtp://your-server.com:25  (for unencrypted)
SMTP Server: smtp://your-server.com:587 (for STARTTLS)
SMTP Server: smtp://your-server.com:465 (for SSL/TLS)
Username: your.username
Password: your.password
```

## Configuration

### Security Settings
- **SSL/TLS**: Always enabled with certificate verification
- **Authentication**: SMTP AUTH with username/password
- **Connection**: Secure STARTTLS or SSL/TLS connections

### Supported Features
- Multiple recipients in single send
- Plain text email body
- Custom headers (via message formatting)
- Proxy support (HTTP/SOCKS)
- Verbose logging for troubleshooting

## Examples

### Send Email with Multiple Recipients
```bash
./send_mail
# Follow prompts, entering multiple email addresses when asked for recipients
```

### Send Email through Corporate Proxy
```bash
./send_mail
# Enter proxy: http://proxy.company.com:8080
# Continue with SMTP configuration
```

### Troubleshooting with Verbose Output
The program automatically enables verbose curl output showing:
- DNS resolution
- SSL/TLS handshake details
- SMTP conversation
- Authentication steps

## Error Messages and Solutions

### "URL rejected: Malformed input to a URL function"
**Cause**: Invalid SMTP server URL format  
**Solution**: Use format: `smtp://server:port` (e.g., `smtp://smtp.gmail.com:587`)

### "An error has happened: Login denied"
**Cause**: Invalid credentials or authentication method  
**Solution**: 
- Check username/password
- For Gmail/Yahoo, use App Password instead of account password
- Verify SMTP server supports your authentication method

### "SSL certificate problem: self-signed certificate"
**Cause**: Certificate verification failure  
**Solutions**:
- Use a proper SSL certificate from your CA
- For testing only: export `CURL_CA_BUNDLE=/path/to/cacert.pem`

### "Network is unreachable"
**Cause**: Network connectivity or firewall issues  
**Solutions**:
- Check internet connection
- Verify firewall allows outbound SMTP (ports 25, 587, 465)
- Try with proxy if required

## Development

### Project Structure
```
smtp_client/
├── examples/cpp/
│   ├── src/main.cpp          # Main application code
│   ├── CMakeLists.txt        # CMake configuration
│   ├── CMakePresets.json     # CMake presets
│   └── conanfile.txt         # Conan dependencies (optional)
└── docs/
    ├── TECHNICAL.md          # Technical documentation
    └── BUILD.md              # Detailed build instructions
```

### Dependencies
- **libcurl**: HTTP/SMTP client library
- **OpenSSL**: SSL/TLS encryption (usually bundled with libcurl)
- **CMake**: Build system
- **C++20**: Modern C++ features

### Build Options
```bash
# Debug build
cmake -DCMAKE_BUILD_TYPE=Debug ..

# Release build (default)
cmake -DCMAKE_BUILD_TYPE=Release ..

# Custom install location
cmake -DCMAKE_INSTALL_PREFIX=/opt/smtp_client ..
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests if applicable
5. Submit a pull request

## Security Notes

- **Never hardcode credentials** in source code
- **Use App Passwords** for services like Gmail/Yahoo
- **Store credentials securely** when automating
- **Verify SSL certificates** - don't disable verification in production
- **Use environment variables** for sensitive configuration

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

## Disclaimer

Please ensure compliance with your email provider's terms of service when using this SMTP client.

## Support

For issues and questions:
1. Check the [Technical Documentation](docs/TECHNICAL.md)
2. Review the [Build Guide](docs/BUILD.md)
3. Verify your SMTP server configuration
4. Test with different credentials or servers

---

**Disclaimer**: This tool is for legitimate email sending only. Ensure you have permission to send emails through the configured SMTP server and comply with all applicable laws and regulations.