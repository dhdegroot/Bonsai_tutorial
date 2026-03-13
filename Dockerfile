
# Use an official Python runtime as a parent image
FROM python:3.9-slim

# lets use bash
SHELL ["/bin/bash", "-c"]
# Install system dependencies: git + OpenMPI
RUN apt-get update \
	&& apt-get install -y --no-install-recommends \
		git \
		openmpi-bin \
		libopenmpi-dev \
		libhdf5-dev \
        gcc \
        g++ \
        make

# get Sanity
WORKDIR /sanity
RUN git clone --depth 1 https://github.com/jmbreda/Sanity /sanity
RUN cd src && make clean && make 

# Clone the Bonsai data representation repo into /bonsai
WORKDIR /bonsai
RUN git clone --depth 1 https://github.com/dhdegroot/Bonsai-data-representation /bonsai
# Install Python dependencies from the cloned repository
RUN pip install --no-cache-dir -r requirements_bonsai_scout.txt mpi4py
# cellstates
WORKDIR /cellstates
RUN git clone --depth 1 https://github.com/nimwegenLab/cellstates /cellstates
RUN python -m venv cellstates_venv
RUN source cellstates_venv/bin/activate && pip install --no-cache-dir "scipy<1.13" numpy pandas cython matplotlib
RUN source cellstates_venv/bin/activate &&  python setup.py build_ext
RUN source cellstates_venv/bin/activate && python setup.py install
# clean
RUN apt purge -y --auto-remove git gcc g++ make && apt clean && apt autoremove -y && rm -rf /var/lib/apt/lists/* && pip cache purge
WORKDIR /mnt
EXPOSE 8000
CMD ["tail","-f","/dev/null"]