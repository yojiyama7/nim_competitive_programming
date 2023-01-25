import subprocess
import platform

pf = platform.system()
if pf == 'Windows':
    subprocess.run("cd .. & python manage_dir.py", shell=True, encoding="shift-jis")
if pf == 'Darwin':
  	subprocess.run("cd ..; python manage_dir.py", shell=True)
if pf == 'Linux':
	print('on Linux')
