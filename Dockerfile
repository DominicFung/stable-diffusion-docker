FROM tensorflow/tensorflow:2.10.0-gpu

RUN pip install diffusers pillow torch transformers boto3 \
  --extra-index-url https://download.pytorch.org/whl/cu116

RUN useradd -m huggingface

USER huggingface

WORKDIR /home/huggingface

RUN mkdir -p /home/huggingface/.cache/huggingface \
  && mkdir -p /home/huggingface/output

COPY service-v1.py /usr/local/bin
COPY token.txt /home/huggingface

USER root
RUN chmod +x /usr/local/bin/service-v1.py

USER huggingface

ENTRYPOINT [ "service-v1.py" ]