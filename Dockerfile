# FROM nvcr.io/nvidia/pytorch:24.01-py3
FROM uhub.service.ucloud.cn/registry.uic.io/pytorch:24.01-py3

WORKDIR /app

COPY . /app/

RUN cd /tmp \
    && wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-py310_24.1.2-0-Linux-x86_64.sh \
    && bash Miniconda3-py310_24.1.2-0-Linux-x86_64.sh -b -p /usr/local/miniconda3 \
    && /usr/local/miniconda3/bin/conda init $(basename "${SHELL}") \
    && source ~/.bashrc \
    && rm -rf /tmp/*

RUN eval "$(/usr/local/miniconda3/bin/conda shell.bash hook)" \
    && python -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
    && python -m pip install --upgrade pip \
    && cd /app \
    && pip install -r requirements.txt \
    && pip install -e .[deepspeed,metrics,bitsandbytes,qwen] \
    && rm -rf /tmp/*

EXPOSE 7860

CMD [ "llamafactory-cli", "webui" ]