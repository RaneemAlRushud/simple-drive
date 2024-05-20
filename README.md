# README

> Ruby (3.1.5p252), Rails (7.1.3.2)
<br>
<br>


**Table of Contents**
* [Application Structure](#application-structure)
* [Building and Running the app](#application-structure)
* [Curl Requests](#testing-strategy)
* [Testing](#building-and-running-the-application)
* [Scenarios](#data-storage-options)

***
## 💠 Solution Architecture 

<p align= "center"> <img width="700" alt="SimpleDrive-solution-design" src="https://github.com/RaneemAlRushud/simple-drive/assets/59771760/a8de4f49-1cd2-46e7-8314-010f84998ed3"> </p>

## 💠 Building and Running the app
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
- ### ✦ Generate token
```
curl -XPOST localhost:3000/v1/token --data '{"email": "raneemalrashoud@gmail.com"}' --header "Content-Type: application/json"
```

- ### ✦ Create blob
- Request:

```
curl -v -XPOST localhost:3000/v1/blobs --data '{"id": "8455F420-F02E-45F9-8123-D5454A84147A", "data": "yixyvRL2c+8b/pe4CuV+vw=="}' --header "Content-Type: application/json" --header 'Authorization: Bearer <generated-token>'
```

- Response:
```
{
  "id": "8455F420-F02E-45F9-8123-D5454A84147A",
  "success": true
}
```

- ### ✦ Get blob
- Request:
```
curl localhost:3000/v1/blobs/<id> --header 'Authorization: Bearer <generated-token>'
```

- Response:
```
{
  "id":"8455F420-F02E-45F9-8123-D5454A84147A",
  "data":"yixyvRL2c+8b/pe4CuV+vw==",
  "size":24,
  "created_at":"2024-05-20T07:02:20.753Z"
  }
```

- ### ✦ Get all blobs
```
curl localhost:3000/v1/blobs --header 'Authorization: Bearer <generated-token>'
```

## 💠 Scenarios (Data Storage Options)
### a. Amazon S3 Compatible Storage
<p align= "center"> <img width="600" alt="aws-s3" src="https://github.com/RaneemAlRushud/SimpleDrive/assets/59771760/253746ee-9181-4b11-bb0c-fa2e331da48b"> </p>

### b. FTP
<p align= "center"> <img width="600" alt="FTP" src="https://github.com/RaneemAlRushud/SimpleDrive/assets/59771760/43bd3380-1f46-464e-b98a-d4f5ea5dfadd"> </p>

### c. Postgres DB
<p align= "center"> <img width="600" alt="DB" src="https://github.com/RaneemAlRushud/SimpleDrive/assets/59771760/2f230c57-cbc2-491d-a5cb-24930658b23b"> </p>

### d. Local Storage 
<p align= "center"> <img width="600" alt="FTP" src="https://github.com/RaneemAlRushud/simple-drive/assets/59771760/d217390a-07dc-4b0c-a042-c5f2688fced7"> </p>


## 💠 Testing


- ### ✦ Unit Testing

  
- ### ✦ Integration Testing



## 💠 References 
- [Create a signed AWS API request](https://docs.aws.amazon.com/IAM/latest/UserGuide/create-signed-request.html)
- [Amazon S3 REST API with curl](https://czak.pl/2015/09/15/s3-rest-api-with-curl.html)
- [File Transfer Protocol (FTP)](https://www.scaler.com/topics/computer-network/file-transfer-protocol/)
- [Net::FTP](https://ruby-doc.org/stdlib-2.4.0/libdoc/net/ftp/rdoc/Net/FTP.html)
- [rspec](https://rspec.info/)