    dock2.vm.provision "shell", inline: <<-SCRIPT
      sudo su - -c 'echo "192.168.33.200    dock.repo.co.kr" >> /etc/hosts'
      sudo openssl req -newkey rsa:4096 -nodes -sha256 \
        -keyout dock.repo.co.kr.key \
        -subj "/C=KR/ST=Korea/L=Busan/O=mzcloud/OU=mzcloud/CN=dock.repo.co.kr/emailAddress=mw980718@gmail.com" \
        -addext "subjectAltName = DNS:dock.repo.co.kr" -x509 -days 365 \
        -out dock.repo.co.kr.crt
      mkdir certs/
      sudo mv dock.repo.co.kr.* certs/
      sudo mkdir -p /etc/docker/certs.d/dock.repo.co.kr/
      sudo cp certs/dock.repo.co.kr.crt /etc/docker/certs.d/dock.repo.co.kr/
      sudo cp certs/dock.repo.co.kr.crt /usr/local/share/ca-certificates/
      docker pull registry
      docker run -d --restart=always --name image_repo \
        -v /home/vagrant/certs:/certs \
        -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
        -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/dock.repo.co.kr.crt \
        -e REGISTRY_HTTP_TLS_KEY=/certs/dock.repo.co.kr.key \
        -p 443:443 registry
    SCRIPT