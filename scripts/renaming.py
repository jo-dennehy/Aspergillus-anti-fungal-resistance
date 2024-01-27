import os

# get root directory that script is running in
root_directory = os.fsencode(os.getcwd())

# loop through each file in root directory
for directory in os.listdir(root_directory):
    # check if file is directory
    if os.path.isdir(directory):
        # rename every file in the directory that starts with 'out'
        for file in os.listdir(directory):
            filename = os.fsencode(file)
            if filename.startswith(b"out"):
                os.rename(root_directory + '/'.encode('utf-8') + directory + '/'.encode('utf-8') + file, 
                          root_directory + '/'.encode('utf-8') + directory + '/'.encode('utf-8') + os.path.basename(directory) + '_'.encode('utf-8') + file)
