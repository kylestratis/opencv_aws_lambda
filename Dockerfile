FROM amazonlinux

WORKDIR /
RUN yum update -y

# Install Python 3.7
RUN yum install python3 zip -y

# Install Python packages
RUN mkdir /packages
RUN echo "opencv-python" >> /packages/requirements.txt
RUN cat /packages/requirements.txt
RUN mkdir -p /packages/opencv-python-3.7/python/lib/python3.7/site-packages
RUN pip3.7 install --upgrade pip
RUN pip3.7 install --upgrade setuptools
RUN pip3.7 install -r /packages/requirements.txt -t /packages/opencv-python-3.7/python/lib/python3.7/site-packages

# Create zip files for Lambda Layer deployment
WORKDIR /packages/opencv-python-3.7/
RUN zip -r9 /packages/cv2-python37.zip .
WORKDIR /packages/
RUN rm -rf /packages/opencv-python-3.7/
