# README

> Ruby (3.1.5p252), Rails (7.1.3.2)
<br>


## 💠 Table of Contents
* [Solution Architecture](#solution-architecture)
* [Building and Running](#building-and-running)
* [Curl Requests](#curl-requests)
* [Testing](#testing)
* [Scenarios (Data Storage Options)](#data-storage-options)
* [References](#references)

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

###  a. ✦ Amazon S3 Compatible Storage

<p align= "center"> <img width="600" alt="aws-s3" src="https://github.com/RaneemAlRushud/simple-drive/assets/59771760/0ce929ae-6748-44b5-b4c3-f36c996ede92"> </p>

###  b. ✦ FTP

<p align= "center"> <img width="600" alt="FTP" src="https://github.com/RaneemAlRushud/simple-drive/assets/59771760/2e7e9812-96f6-4bf7-8304-e3587eb2d414"> </p>

###  c. ✦ Postgres DB

<p align= "center"> <img width="600" alt="DB" src="https://github.com/RaneemAlRushud/simple-drive/assets/59771760/fcd175c6-1e03-42a1-a947-26f0cf0aa514"> </p>

###  d. ✦ Local Storage 

<p align= "center"> <img width="600" alt="FTP" src="https://github.com/RaneemAlRushud/simple-drive/assets/59771760/3ea58fa5-b0a2-4c34-8117-e1d9a9c8b229"> </p>


## 💠 Testing
### ✦ Utilized Testing Toolkit:
  - [rspec-rails](https://rspec.info/)
  - [factory_bot_rails](https://github.com/thoughtbot/factory_bot_rails)
  - [faker](https://github.com/faker-ruby/faker.git)

    <br>
  
### ✦ Unit Testing
- a. User API request
  
| # | #1 | #2 | 
|:-------------:|:-:|:-:|
| Test use-case  | 200: generate token | 200: existing email passed | 
  

- b. Blob API request
  
| # | #1 | #2 | #3 | #4 | #5 |
|:-------------:|:-:|:-:|:-:|:-:|:-:|
| Test use-case  | 201: post data | 200: get data by id | 401: unauthenticated | 400: invalid base64 | 400: existed id |


  <br> 
  
### ✦ Integration Testing
- In our case, it scopes the data storage services:


| # | #1 | #2 | #3 | #4 |
|:-------------:|:-:|:-:|:-:|:-:|
| Test use-case  | 201,200: store and retrieve from S3 | 201,200: store and retrieve from FTP | 201,200: store and retrieve from DB | 201,200: store and retrieve from Local |



## 💠 References 
- [Create a signed AWS API request](https://docs.aws.amazon.com/IAM/latest/UserGuide/create-signed-request.html)
- [Amazon S3 REST API with curl](https://czak.pl/2015/09/15/s3-rest-api-with-curl.html)
- [File Transfer Protocol (FTP)](https://www.scaler.com/topics/computer-network/file-transfer-protocol/)
- [Net::FTP](https://ruby-doc.org/stdlib-2.4.0/libdoc/net/ftp/rdoc/Net/FTP.html)
- [rspec](https://rspec.info/)
