def find_errors(log_file, error_keyword="ERROR"):
    count = 0
    try:
        with open(log_file, "r") as f:
            for line in f:
                if error_keyword in line:
                    print(line.strip())
                    count += 1
        print(f"Всего ошибок: {count}")
    except FileNotFoundError:
        print(f"Ошибка: Файл {log_file} не найден!")
    except Exception as e:
        print(f"Произошла ошибка: {e}")

# find_errors("server.log") # по умолчанию будет искать ERROR