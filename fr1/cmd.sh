docker container exec -it manager docker node ls
docker container exec -it manager \
docker network create --driver=overlay --attachable todoapp
git clone https://github.com/takagotch/tododb

cd tododb

mysql -h $MYSQL_MASTER_HOST ...
CREATE USR IF NOT EXISTS 'ReplicationUserName'@'SlaveHostIpAddr' identified by 'ReplicationPassword';
GRANT REPLICATION SLAVE on *.* to 'ReplicationUserName'@'SlaveHostIpAddr';

show master status;
CHANGE MASTER TO MASTER_HOST='master', MASTER_USER='repl', MASTER_PASSWORD='tky', MASTER_LOG_FILE='mysql-bin.000003', MASTER_LOG_POS=605;

docker image build -t tky/tododb:latest .
docker image tag tky/todbdb:latest localhost:5000/tky/tododb:latest
docker image push localhost:5000/tky/tododb:latest

docker container exec -it manager \
	docker stack deploy -c /stack/todb-mysql.yml todo_mysql

docker container exec -it manager \
	docker service ls

docker container exec -it manager \
	docker service ps todo_mysql_master --no-trunc \
	--filter "desired-state=running"

docker container exec -it xxx \
	docker container exec -it todo_mysql_master.1.xxx bash root@xxx:/#

docker container exec -it manager \
	docker service ps todo_mysql_master \
	--no-trunc \
	--filter "desired-state=running" \
	--format "docker container -it {{.Node}} docker container exec -it {{.Name}}.{{.ID}} bash"

docker container exec -it xxx \
	docker container exec -it todo_mysql_master.1.xxx \
	init-data.sh

docker container exec -it xxx \
	docker container exec -it todo_mysql_master.1.xxx \
	mysql -u tky -pgtky tododb

SELECT * FROM todo LIMIT 1\G

docker container exec -it manager \
	docker service ps todo_mysql_slave \
	--not-trunc \
	--filter "desired-state=running" \
	--format "docker container exec -it {{.Node}} docker container exec -it {{.Name}}.{{.ID}} bash"

docker container exec -it xxx \
	docker container exec -it todo_mysql_slave.1.xxx \
	mysql -u tky -ptky

SELECT * FROM todo LIMIT 1\G

tree -a -I '.git|.gitignore' .


curl -s XGET http://localhost:8080/todo?status=TODO | jq .
curl -XPOST -d '{
  "title": "text",
  "content": "text"
}' http://localhost:8080/todo

curl -XPUT -d '{
  "id": 1,
  "title": "txt",
  "content": "txt",
  "status": "PROGRESS"
}' http://localhost:8080/todo

docker image build -t tky/todoapi:latest .
docker image tag tky/todoapi:latest localhost:5000/tky/todoapi:latest
docker image push localhost:5000/tky/todoapi:latest


docker container exec -it manager docker stack deploy -c /stack/todo-app.yml todo_app
docker container exec -it manager -it manager docker service logs -f todo_app_api

git clone https://github.com/tky/todonginx
cd todonginx
tree .
tree .

docker image build -t tky/nginx:latest .
docker image tag tky/nginx:latest localhost:5000/tky/nginx:latest
docker image push localhost:5000/tky/nginx:latest

docker container exec -it manager docker stack deploy -c /stack/todo-app.yml todo_app

git clone https://github.com/tky/todoweb
tree .

npm install
npm run build
npm run start


docker image build -t tky/todoweb:latest .
docker image tag tky/todoweb:latest localhost:5000/tky/todoweb:latest
docker image push localhost:5000/tky/todoweb:latest

.nuxt/dist

cp etc/nginx/conf.dpublic.conf.tmpl etc/nginx/conf.d/nuxt.conf.tmpl

docker image build -f Dockerfile-nuxt -f tky/nginx-nuxt:latest .
docker image tag tky/nginx-nuxt:latest localhost:5000/tky/nginx-nuxt:latest
docker image push localhost:5000/tky/nginx-nuxt:latest

docker container exec -it manager \
	docker stack deploy -c /stack/todo-frontend.yml todo_frontend

docker container exec -it manager \
	docker stack deploy -c /stack/todo-ingress.yml todo_ingress

curl -I http://localhost:8000/

curl -I http://localhost:8000/_nuxt/app.xxx.js

