import os
import shutil
from datetime import datetime

def backup_files(source_path, backup_dir):
    if not os.path.exists(source_path):
        print(f"Ошибка: {source_path} не существует!")
        return
    
    os.makedirs(backup_dir, exist_ok=True)

    timestamp = datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    if os.path.isfile(source_path):
        backup_name = f"{os.path.basename(source_path)}_{timestamp}"
    else:
        backup_name = f"{os.path.basename(source_path.rstrip('/'))}_{timestamp}"
    backup_path = os.path.join(backup_dir, backup_name)

    try:
        if os.path.isfile(source_path):
            shutil.copy2(source_path, backup_path)
        else:
            shutil.copytree(source_path, backup_path)
        print(f"Резервная копия создана: {backup_path}")
    except Exception as e:
        print(f"Ошибка при копировании: {e}")

# backup_files("/введите/папку/или/путь_до_файла", "/куда/хотите_скопировать")