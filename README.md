<a name="readme-top"></a>
<div align="center">

<!-- <a href="#">
  <img src="https://github.com/katorlys/.github/blob/main/assets/mark/mark.png" height="100">
</a><br> -->

<h1>
  aionui-docker
</h1>

<p>
  Docker image for self-hosting AionUi
</p>

[![Pull Requests][github-pr-badge]][github-pr-link]
[![Issues][github-issue-badge]][github-issue-link]
[![License][github-license-badge]](LICENSE)

</div>


<!-- Main Body -->

## Introduction
Docker image for self-hosting AionUi - the free, open-source Cowork app with AI Agents.

[AionUi](https://github.com/iOfficeAI/AionUi) is licensed under [Apache License 2.0](https://github.com/iOfficeAI/AionUi/blob/db1812ab7f90f50479e49d901c070d9a89942426/LICENSE).

AionUi stopped publishing the standalone Web CLI tarballs to GitHub Releases after [`v2.1.47-final`](https://github.com/iOfficeAI/AionUi/releases/tag/v2.1.47-final). This image builds the standalone Web CLI from AionUi source.


## Username & password
The default username is `admin` and to get the password, check the logs of the container when it is first started.
```sh
docker logs aionui
```

The username and password cannot be changed. To reset the password, simply 
```sh
docker exec aionui /opt/aionui-web/aionui-web resetpass --data-dir /data
```
For Docker Compose, use the following command to reset the password:
```sh
docker compose exec aionui /opt/aionui-web/aionui-web resetpass --data-dir /data
```


## Usage
### Docker
```sh
docker run -d \
  --name aionui \
  -p 3000:25808 \
  -e AIONUI_HOST=0.0.0.0 \
  -e AIONUI_PORT=25808 \
  -e AIONUI_ALLOW_REMOTE=1 \
  -e AIONUI_OPEN_BROWSER=0 \
  -e AIONUI_DATA_DIR=/data \
  -e AIONUI_LOG_DIR=/logs \
  -v ./data:/data \
  -v ./logs:/logs \
  katorlys/aionui:latest
```
### Docker Compose
```yml
services:
  aionui:
    image: katorlys/aionui:latest
    container_name: aionui
    restart: unless-stopped
    ports:
      - "3000:25808"
    environment:
      AIONUI_HOST: 0.0.0.0
      AIONUI_PORT: 25808
      AIONUI_ALLOW_REMOTE: "1"
      AIONUI_OPEN_BROWSER: "0"
      AIONUI_DATA_DIR: /data
      AIONUI_LOG_DIR: /logs
    volumes:
      - ./data:/data
      - ./logs:/logs
```


## Build
Build the latest version:
```sh
docker build --platform linux/amd64,linux/arm64 -t aionui:latest .
```
Build a specific AionUi version:
```sh
docker build --platform linux/amd64,linux/arm64 --build-arg AIONUI_VERSION=2.1.20 -t aionui:2.1.20 .
```

<!-- /Main Body -->


<div align="right">
  
[![BACK TO TOP][back-to-top-button]](#readme-top)

</div>

---

<div align="center">

<p>
  Copyright &copy; 2026-present <a target="_blank" href="https://github.com/katorlys">Katorly Lab</a>
</p>

[![License][github-license-badge-bottom]](LICENSE)

</div>

[back-to-top-button]: https://img.shields.io/badge/BACK_TO_TOP-151515?style=flat-square
[github-pr-badge]: https://img.shields.io/github/issues-pr/katorlys-samples/aionui-docker?label=pulls&labelColor=151515&color=79E096&style=flat-square
[github-pr-link]: https://github.com/katorlys-samples/aionui-docker/pulls
[github-issue-badge]: https://img.shields.io/github/issues/katorlys-samples/aionui-docker?labelColor=151515&color=FFC868&style=flat-square
[github-issue-link]: https://github.com/katorlys-samples/aionui-docker/issues
[github-license-badge]: https://img.shields.io/github/license/katorlys-samples/aionui-docker?labelColor=151515&color=EFEFEF&style=flat-square
<!-- https://img.shields.io/badge/license-CC_BY--NC--SA_4.0-EFEFEF?labelColor=151515&style=flat-square -->
[github-license-badge-bottom]: https://img.shields.io/github/license/katorlys-samples/aionui-docker?labelColor=151515&color=EFEFEF&style=for-the-badge
<!-- https://img.shields.io/badge/license-CC_BY--NC--SA_4.0-EFEFEF?labelColor=151515&style=for-the-badge -->
