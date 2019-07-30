### Find out what process is running on port 8080

lsof -n -i4TCP:8080  
(PID is the second "column")


### Kill process

sudo kill -9 <PID>  
(PID is from above function)


### Start simple server

python -m SimpleHTTPServer 8000  
(start in folder you want to use as the home directory)