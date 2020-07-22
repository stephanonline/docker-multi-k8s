docker build -t stephanonline/multi-client:latest -t stephanonline/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t stephanonline/multi-server:latest -t stephanonline/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t stephanonline/multi-worker:latest -t stephanonline/multi-worker:$SHA -f ./worker/Dockerfile ./worker

docker push stephanonline/multi-client:latest
docker push stephanonline/multi-server:latest
docker push stephanonline/multi-worker:latest

docker push stephanonline/multi-client:$SHA
docker push stephanonline/multi-server:$SHA
docker push stephanonline/multi-worker:$SHA

kubectl create secret generic pgpassword --from-literal PGPASSWORD=$PGPASSWORD
kubectl apply -f k8s
kubectl set image deployments/client-deployment client=stephanonline/multi-client:$SHA
kubectl set image deployments/server-deployment server=stephanonline/multi-server:$SHA
kubectl set image deployments/worker-deployment worker=stephanonline/multi-worker:$SHA