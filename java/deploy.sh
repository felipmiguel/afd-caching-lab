# retrieve parameters for terraform output
cd ../tf
echo 'Retrieving parameters from terraform output'
RESOURCE_GROUP=$(terraform output -raw resource_group)
SERVICE_NAME=$(terraform output -raw spring_apps_service_name)

# build and deploy the app
cd ../java
echo 'Building and deploying the app'
mvn clean package
az spring app deploy -s $SERVICE_NAME -g $RESOURCE_GROUP -n gateway --artifact-path gateway/target/gateway-0.0.1-SNAPSHOT.jar &
az spring app deploy -s $SERVICE_NAME -g $RESOURCE_GROUP -n cache-poc --artifact-path cache-poc/target/cache-poc-0.0.1-SNAPSHOT.jar  &

wait
