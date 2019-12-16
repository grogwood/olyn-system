olyn_system

### System User Passwords
System user passwords are stored inside the `system_users` data bag.
Passwords for the user must be encrypted using a password shadow hash before going into the unencrypted data bag.

To encrypt a user's password using shadown hash:  
`mkpasswd -m sha-512`

### SSL Certificate Setup

To generate a CSR for a 3rd party cert:  
`openssl req -new -newkey rsa:4096 -nodes -keyout website.com.key -out website.com.csr`

Take the CSR to the 3rd party generator and complete cert issuance.
Create or modify records for the cert inside the `ssl_certificate` data bag. Copy/paste all files to be copied to the server.

#### PEM files
PEM files are needed for services like haproxy. You can create a PEM file by combining all SSL files together in a chain.
The order of files is:

`PRIVATE KEY`  
`PUBLIC CERTIFICATE`  
`CA BUNDLE`