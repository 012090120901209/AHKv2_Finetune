import os

def list_ahk_files():
    ahk_files = []
    for root, dirs, files in os.walk('data/Scripts'):
        for file in files:
            if file.endswith('.ahk'):
                full_path = os.path.join(root, file)
                ahk_files.append(full_path)
    with open('ahk_files_list.txt', 'w') as f:
        for path in ahk_files:
            f.write(path + '\n')

if __name__ == '__main__':
    list_ahk_files()