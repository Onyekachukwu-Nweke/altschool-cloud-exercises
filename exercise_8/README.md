# Exercise 8

**Task**
Create an Ansible Playbook to setup a server with Apache
The server should be set to the Africa/Lagos Timezone
Host an index.php file with the following content, as the main file on the server:

```
<?php
date("F d, Y h:i:s A e", time());
?>
```

**_Instruction:_**
Submit the Ansible playbook, the output of systemctl status apache2 after deploying the playbook and a screenshot of the rendered page

## Procedure
- I configured my inventory.yaml file to carry the host I want to use ansible to operate on
- I wrote a playbook.yaml file that carries the configuration of apache as well as the tasks for the exercise
