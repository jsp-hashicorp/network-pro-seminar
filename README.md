# Consul을 이용한 네트워크 미들웨어 자동화

다음 3개 디렉토리로 구성
- as3 :  AS3를 사용하여 Pool 구성과 Pool Memeber 추가 등 BIG-IP 구성 작업 수행
- scripts : AS3 및 인스턴스 구성 시 사용할 스크립트
- terraform : BIG-IP, Consul 및 Nginx 인스턴스 배포를 위한 Terraform Configuration template


## Demo 수행 순서
데모는 다음 순서로 진행
1. terraform 디렉토리 상의 Configuration template을 사용하여, AWS상에 데모 환경 구성
2. as3 디렉토리를 이용하여, BIG-IP 환경 구성
3. terraform 디렉토리 상의 nginx.tf 내 ASG (desired capacity)를 수정/반영하면서 테스트


