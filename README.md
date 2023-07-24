# cp2
Caso Práctico 2 - UNIR

Despliega una Infraestructura en Azure mediante Terraform y la configura utilizando Ansible.

1- Servicio de Kubernetes<br />
2- Maquina Virtual<br />
3- Un Repositorio de Contenedores Privado (ACR)<br />

Para poderlo gestionar de manera automática, se facilita un script llamado deploy.sh que ejecuta el despliegue de la Infraestructura y, con los datos obtenidos de la infraestructura, llama a Ansible para configurar la Infraestructura.

<h1>deploy.sh</h1>
Este script tiene como objetivo explorar más allá de los conocimientos necesarios para caso práctico 2. Se trata de un ejemplo académico. En un entorno real, seria muy peligroso ejecutar este script ya que automáticamente desplegaria la infraestructura.<br />
Recomendaria revisar el plan y luego ejecutar manualmente el terraform apply.<br />
En cualquier caso, como ejercicio academico, es muy completo.<br />
deploy.sh tras realizar unas comprovaciones de los argumentos, llama ejecuta los comandos de Terraform y después, ejecuta los comandos de Ansible.<br />
No comprueba si Terraform ha ido bien para lanzar Ansible.<br />
El script permite los siguientes argumentos

<b>./deploy.sh [entorno=dev||prod] [--terraform-refresh||--only-diagrams]</b>

El primer argumento se utiliza para conocer el entorno "dev" o "prod", pues existen distintas variables de Terraform que son distintas en función del entorno.<br />
El segundo argumento es para condicionar la ejecución del script. <br />
  --terraform-refresh : Si indicamos este segundo argumento, solamente ejecuta el terraform refresh y terraform output<br />
  --only-diagrams : Si indicamos este segundo argumento, regenera el diagrama con Pluralith mediante el terraform.tfstate existente.

<h5>Ejecución:</h5>
<i><b>./deploy.sh dev</b></i>


<h2>Terraform:</h2>
terraform init<br />
terraform plan -out=myplan -var env=%arg1%<br />
terraform apply myplan<br />
terraform refresh<br />

Finalmente ejecuta terraform output para todas las variables que requiere ansible.

<h2>Ansible:</h2>
Automaticamente crea un fichero de inventory con la IP de la VM.<br />
Después, el script itera en la carpeta ansible sobre todos los ficheros con extensión .yaml, que presupone son playbooks. Para este caso, existen 4 playbooks distintos.<br />
00_playbook.yaml : Instala los paquetes necesarios para el correcto funcionamiento del contenedor y los comandos a ejecutar.<br />
01_playbook.yaml : Ejecuta los comandos necesarios para montar y crear la imagen que se requiere para el caso práctico.<br />
02_playbook.yaml : Instancia en el demonio del sistema del OS e inicializa el contenedor, con el volumen persistence asociado.<br />
03_playbook.yaml : Ejecuta los comandos necesarios para crear un namespace,pv, pvc y pod en AKS para servir un SGBD MySQL 5.7<br />


<h5>Nota: </h5>
Cuando Ansible encuentra una nueva huella SSH, la ejecución de ansible se para hasta que aceptamos o no la huella SSH del servidor.<br />
Para evitar que la ejecución se pare, podemos añadir esta opción en el fichero de configuración de ansible "/etc/ansible/ansible.cfg".
[defaults]<br />
host_key_checking = False<br />
