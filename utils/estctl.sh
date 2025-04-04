#!/bin/bash

SUPERVISOR_CONF="/etc/supervisor/conf.d/supervisord.conf"
LOG_FILE="/tmp/estserver.log"
PROGRAM_NAME="estserver"

function show_help() {
  echo "Usage: $0 [command]"
  echo ""
  echo "Commands:"
  echo "  status        Show supervisor status of all services"
  echo "  log           Show contents of EST server log"
  echo "  tail          Tail EST server logs using supervisorctl"
  echo "  restart       Restart the estserver process via Supervisor"
  echo "  help          Show this help message"
}

function check_status() {
  supervisorctl -c "$SUPERVISOR_CONF" status all
}

function show_log() {
  if [ -f "$LOG_FILE" ]; then
    cat "$LOG_FILE"
  else
    echo "Log file not found at $LOG_FILE"
  fi
}

function tail_logs() {
  supervisorctl -c "$SUPERVISOR_CONF" tail -f "$PROGRAM_NAME"
}

function restart_server() {
  echo "Restarting $PROGRAM_NAME via Supervisor..."
  supervisorctl -c "$SUPERVISOR_CONF" restart "$PROGRAM_NAME"
  echo "Restarted $PROGRAM_NAME with new PID..."
  supervisorctl -c "$SUPERVISOR_CONF" status all
}

# Main script logic
case "${1:-}" in
  status)
    check_status
    ;;
  log)
    show_log
    ;;
  tail)
    tail_logs
    ;;
  restart)
    restart_server
    ;;
  help|"")
    show_help
    ;;
  *)
    echo "Unknown command: $1"
    show_help
    exit 1
    ;;
esac
