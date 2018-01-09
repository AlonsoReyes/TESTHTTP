# TESTHTTP

Tests ran in A8 nodes, provided by IoT-LAB, to test efficiency of http2 protocol.


-Pre-steps:

1) Take the necessary steps to be able to connect through ssh. https://www.iot-lab.info/tutorials/configure-your-ssh-access/
2) Request at least one A8 node and connect to it through ssh after connecting to your account in the site.
3) Download the nghttp2 library (https://github.com/nghttp2/nghttp2/releases) in the A8 directory and uncompress the file.
4) Move inside the directory and run the command "./configure && make"
5) Create a directory called "test_server" in the A8 directory and put inside the files you want the server to have available in the tests.
6) Create a directory called "results" in the A8 common directory and inside create a directory called test.

-To run the tests the next steps are needed:

1) Request at least 3 A8 nodes in the grenoble site to the iot-lab.
2) Make an ssh connection to your account in the site. Ex. ssh user@grenoble.iot-lab.info
3) Upload the bash files to the directory. You can use the command sftp user@grenoble.iot-lab.info:/senslab/users/user/A8/results <<< $'put *.sh', where "user" is your username.
4) Go to the results directory and run the start_exp.sh file using "./start_exp.sh". This will create the necessary directories and get the results.
5) To get the results directories use "sftp user@grenoble.iot-lab.info:/senslab/users/user/A8/results <<< $'get -r cl_top \n get -r srv_top \n get -r cl_req \n get -r consumption/client_csv \n get -r consumption/server_csv'". This will only fetch the files that are needed to get the final results.
6) Run the python file called get_results.py using the command "python3 get_results.py". This will create two files in the same local directory called "A8http2_client.csv" and "A8http2_server.csv".


* A copy of the results from a test is in the repository inside a tar file. The scripts will generate a bunch of directories that in the end aren't needed but were in the process and because of a beginner level of bash skills :P.

** If all else fails... Learn about the yocto project and look at the iot-lab repository where they use the project to create the Linux Image currently installed on the A8 nodes. You can build the necessary packages with it and then install them in the nodes.