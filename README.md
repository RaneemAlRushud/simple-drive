# README

> Ruby (3.1.5p252), Rails (7.1.3.2)
<br>
<br>


**Table of Contents**
* [Application Structure](#application-structure)
* [Building and Running the app](#application-structure)
* [Curl Requests](#testing-strategy)
* [Testing](#building-and-running-the-application)

***
## 💠 Application Structure 

<p align= "center"> <img width="700" alt="SimpleDrive-solution-design" src="https://github.com/RaneemAlRushud/simple-drive/assets/59771760/a8de4f49-1cd2-46e7-8314-010f84998ed3"> </p>

## 💠 Building and Running the app


- ruby-3.1.2
- Install dependencies:
  ```
  bundle install
  ```
- Create db:
  ```
   bin/rails db:create
  ``` 
- Migrate db:
  ```
  bin/rails db:migrate
  ```
- Start server:
  ```
  bin/rails s
  ``` 
  
## 💠 Curl Requests 
- Generate token
```
curl -XPOST localhost:3000/v1/token --data '{"email": "raneemalrashoud@gmail.com"}' --header "Content-Type: application/json"
```

- Create blob
```
curl -v -XPOST localhost:3000/v1/blobs --data '{"id": "9a098146-4b22-4865-98f6-8eab7985kk1c", "data": "YWRmYXNkZmFzZGZhc2Rm"}' --header "Content-Type: application/json" --header 'Authorization: Bearer <generated-token>'
```

- Get blob
```
curl localhost:3000/v1/blobs/<id> --header 'Authorization: Bearer <generated-token>'
```

- Get all blobs
```
curl localhost:3000/v1/blobs --header 'Authorization: Bearer <generated-token>'
```

## 💠 Testing
- Unit Testing
  
- Integration Testing
`bundle exec rspec`

## 💠 References 
- [Create a signed AWS API request](https://docs.aws.amazon.com/IAM/latest/UserGuide/create-signed-request.html)
- [Amazon S3 REST API with curl](https://czak.pl/2015/09/15/s3-rest-api-with-curl.html)
- [File Transfer Protocol (FTP)](https://www.scaler.com/topics/computer-network/file-transfer-protocol/)
- [Net::FTP](https://ruby-doc.org/stdlib-2.4.0/libdoc/net/ftp/rdoc/Net/FTP.html)

