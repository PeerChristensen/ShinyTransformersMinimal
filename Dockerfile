FROM continuumio/miniconda3

RUN apt-get update -y; apt-get upgrade -y; \
    apt-get install -y vim-tiny vim-athena ssh r-base-core \
    build-essential gcc gfortran g++ 

# SETUP ENVIRONMENT
COPY environment.yml environment.yml
RUN conda env create -f environment.yml

RUN echo "conda activate my_env" >> ~/.bashrc

ENV CONDA_EXE /opt/conda/bin/conda
ENV CONDA_PREFIX /opt/conda/envs/my_env
ENV CONDA_PYTHON_EXE /opt/conda/bin/python
ENV CONDA_PROMPT_MODIFIER (my_env)
ENV CONDA_DEFAULT_ENV my_env
ENV PATH /opt/conda/envs/my_env/bin:/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

# GET MODEL
RUN python -c "from transformers import pipeline; pipeline('text-classification',model='bhadresh-savani/distilbert-base-uncased-emotion')"

# INSTALL R PACKAGES
RUN R -e "install.packages(c('dplyr','purrr','ggplot2','shiny','reticulate'), repos = 'http://cran.us.r-project.org')"

COPY . ./

# Give write read/write permission
RUN chmod ugo+rwx ./

EXPOSE 3838

CMD ["R", "-e", "shiny::runApp('/', host = '0.0.0.0', port = 3838)"]
