# System Performance Monitoring Script

This script monitors system performance and logs details such as CPU usage, memory usage, disk usage, and running processes. The output is saved in a timestamped log file for easy reference.

## Features
- Captures a snapshot of system performance using commands like `top`, `vmstat`, `df`, and `ps`.
- Generates logs with date and time in the filename.
- Automatically organizes logs in a designated directory.

## Requirements
- A Linux or Unix-like system.
- Basic shell scripting support (`bash`).

## Usage
1. Clone this repository or download the script.
2. Make the script executable:
    ```bash
    chmod +x script.sh
    ```
3. Run the script:
    ```bash
    ./script.sh
    ```   
4. The logs will be saved in the logs directory with a filename format:
    ```bash
    performance_YYYY-MM-DD_HH-MM-SS.log
    ```

## Log File Structure
A sample log file includes:
- System snapshot using the top command.
- Memory usage details from free.
- Disk usage statistics from df.
- Process summary from ps aux.

## Example Output
Sample log filename:
```
performance_YYYY-MM-DD_HH-MM-SS.log
```

Sample log contents:
![System Log](./images/performance_log.png)

## Customization
You can modify the script to:
- Change the log directory.
- Add or remove commands based on your monitoring needs.

## Notes
- Ensure the script has write permissions in the logs directory.

## License
This project is licensed under the MIT License.