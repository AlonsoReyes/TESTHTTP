# TESTHTTP

Tests ran in A8 nodes, provided by IoT-LAB, to test efficiency of http2 protocol.


*Instructions:

1) Take the necessary steps to be able to connect through ssh. https://www.iot-lab.info/tutorials/configure-your-ssh-access/
2) Create a directory in the repo directory called results if it doesn't exist.
3) Move the files you want the server to have to the test_server directory. It already comes with a simple HTML file and some extras.
4) Request at least 3 A8 nodes in the grenoble site to the iot-lab.
5) In the repo directory run "./start_local.sh -u username" where username is your username in iot-lab.


** A copy of the results from a test is in the repository inside a tar file. The scripts will generate a bunch of directories that in the end aren't needed but were in the process and because of a beginner level of bash skills :P.

** If all else fails... Learn about the yocto project and look at the iot-lab repository where they use the project to create the Linux Image currently installed on the A8 nodes. You can build the necessary packages with it and then install them in the nodes.