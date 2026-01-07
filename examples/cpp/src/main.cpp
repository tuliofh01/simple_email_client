/**
 * MIT License
 * 
 * Copyright (c) 2025 SMTP Client Project
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#include <cstring>
#include <curl/curl.h>
#include <iostream>
#include <ostream>
#include <sstream>
#include <string>
#include <vector>

using namespace std;

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

size_t read_callback(char *target_buffer, size_t size, size_t nitems,
                     void *msg_data) {
  Raw_Message *msg_ctx = static_cast<Raw_Message *>(msg_data);
  size_t ctx_buffer_size = size * nitems;
  if ((msg_ctx->offset_bytes) >= (msg_ctx->data.size())) {
    return 0;
  } else {
    size_t wild_data = (msg_ctx->data.size()) - (msg_ctx->offset_bytes);
    if (wild_data > ctx_buffer_size) {
      wild_data = ctx_buffer_size;
    }
    memcpy(target_buffer, (msg_ctx->data.data() + msg_ctx->offset_bytes),
           wild_data);
    msg_ctx->offset_bytes += wild_data;
    return wild_data;
  }
}

int curl_smtp_exec(Structured_Message target_msg) {
  CURL *curl_handler = curl_easy_init();
  if (!curl_handler) {
    cerr << "Could not start libcurl, check your dependencies." << endl;
    return 1;
  } else {
    curl_easy_setopt(curl_handler, CURLOPT_URL,
                     target_msg.server_address.c_str());
    curl_easy_setopt(curl_handler, CURLOPT_USERNAME,
                     target_msg.credentials.username.c_str());
    curl_easy_setopt(curl_handler, CURLOPT_PASSWORD,
                     target_msg.credentials.password.c_str());
    curl_easy_setopt(curl_handler, CURLOPT_MAIL_FROM,
                     ("<" + target_msg.source_email_address + ">").c_str());
    struct curl_slist *msg_recipients = nullptr;
    for (size_t i = 0; i < target_msg.target_email_addresses.size(); i++) {
      msg_recipients = curl_slist_append(
          msg_recipients,
          ("<" + target_msg.target_email_addresses[i] + ">").c_str());
    }
    curl_easy_setopt(curl_handler, CURLOPT_MAIL_RCPT, msg_recipients);
    curl_easy_setopt(curl_handler, CURLOPT_READFUNCTION, read_callback);
    curl_easy_setopt(curl_handler, CURLOPT_READDATA, &(target_msg.message_raw));
    curl_easy_setopt(curl_handler, CURLOPT_UPLOAD, 1L);
    curl_easy_setopt(curl_handler, CURLOPT_USE_SSL, (long)CURLUSESSL_ALL);
    curl_easy_setopt(curl_handler, CURLOPT_SSL_VERIFYPEER, 1L);
    curl_easy_setopt(curl_handler, CURLOPT_SSL_VERIFYHOST, 2L);
    curl_easy_setopt(curl_handler, CURLOPT_VERBOSE, 1L);
    if (!target_msg.proxy_address.empty()) {
      curl_easy_setopt(curl_handler, CURLOPT_PROXY,
                       target_msg.proxy_address.c_str());
    }
    CURLcode response = curl_easy_perform(curl_handler);
    if (response != CURLE_OK) {
      std::cerr << "An error has happened: " << curl_easy_strerror(response)
                << endl;
      return 1;
    } else {
      curl_slist_free_all(msg_recipients);
      curl_easy_cleanup(curl_handler);
      return 0;
    }
  }
}

Structured_Message msg_setup() {
  Structured_Message msg_obj;
  cout << "Type in your proxy address or leave it blank: ";
  getline(cin, msg_obj.proxy_address);
  cout << "Type in your SMTP server address: ";
  getline(cin, msg_obj.server_address);

  Login_Credentials custom_credentials;
  cout << "Type in your login credentials bellow." << endl;
  cout << "Username: ";
  getline(cin, custom_credentials.username);
  cout << "Password: ";
  getline(cin, custom_credentials.password);
  msg_obj.credentials = custom_credentials;

  cout << "Type in your email address: ";
  getline(cin, msg_obj.source_email_address);

  cout << "Bellow, type in your recipients line by line and finish with a "
          "blank input."
       << endl;
  string aux_list;
  while (true) {
    string aux;
    cout << "Enter a new recipient: ";
    getline(cin, aux);
    if (!aux.empty()) {
      if (!aux_list.empty()) {
        aux_list += ", ";
      }
      msg_obj.target_email_addresses.push_back(aux);
      aux_list += aux;
    } else {
      break;
    }
  }

  cout << "Type in your message subject: ";
  getline(cin, msg_obj.message_subject);

  cout << "Message body, or text (Ctrl+D / Ctrl+Z to finish):\n";
  ostringstream body_stream;
  body_stream << cin.rdbuf();
  msg_obj.message_text = body_stream.str();

  ostringstream raw_content;
  raw_content << "From: <" << msg_obj.source_email_address << ">\r\n"
              << "To: <" << aux_list << ">\r\n"
              << "Subject: " << msg_obj.message_subject << "\r\n"
              << "\r\n"
              << msg_obj.message_text;
  Raw_Message raw_structure;
  raw_structure.data = raw_content.str();
  msg_obj.message_raw = raw_structure;

  return msg_obj;
}

int main() {
  auto custom_msg_obj = msg_setup();
  return curl_smtp_exec(custom_msg_obj);
}
