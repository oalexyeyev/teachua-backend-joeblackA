#!/usr/bin/env python3
import json

def main():
    with open("terraform-output.json") as f:
        data = json.load(f)

    bastion_user = "ec2-user"
    ssh_key_path = "~/.ssh/teachua-key.pem"

    inventory = {
        "_meta": {"hostvars": {}},
        "backend": [],
        "bastion": [],
        "all": []
    }

    backend_ip = data.get("backend_private_ip", {}).get("value")
    bastion_public_ip = data.get("bastion_public_ip", {}).get("value")
    bastion_private_ip = data.get("bastion_private_ip", {}).get("value")  # Додаємо сюди
    db_endpoint = data.get("database_endpoint", {}).get("value")

    # Add bastion host
    if bastion_public_ip:
        inventory["bastion"].append(bastion_public_ip)
        inventory["_meta"]["hostvars"][bastion_public_ip] = {
            "ansible_host": bastion_public_ip,
            "ansible_user": bastion_user,
            "ansible_ssh_private_key_file": ssh_key_path,
            "ansible_ssh_common_args": "-o StrictHostKeyChecking=no",
            "backend_ip": backend_ip 
        }
        inventory["all"].append(bastion_public_ip)

    # Add backend host with ProxyJump through bastion
    if backend_ip:
        inventory["backend"].append(backend_ip)
        inventory["_meta"]["hostvars"][backend_ip] = {
            "ansible_host": backend_ip,
            "ansible_user": bastion_user,
            "ansible_ssh_private_key_file": ssh_key_path,
            "ansible_ssh_common_args": f"-o ProxyJump={bastion_user}@{bastion_public_ip} -o ForwardAgent=yes -o StrictHostKeyChecking=no",
            "bastion_private_ip": bastion_private_ip  # Передаємо приватний IP bastion як змінну
        }
        inventory["all"].append(backend_ip)

    # Add DB endpoint as a hostvar to all hosts
    if db_endpoint:
        for host in inventory["all"]:
            inventory["_meta"]["hostvars"][host]["database_endpoint"] = db_endpoint

    print(json.dumps(inventory, indent=2))


if __name__ == "__main__":
    main()
