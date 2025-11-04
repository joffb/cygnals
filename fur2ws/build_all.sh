env GOOS=linux GOARCH=386 go build
rm ../bin/linux_386/*
mv fur2ws ../bin/linux_386

env GOOS=linux GOARCH=amd64 go build
rm ../bin/linux_amd64/*
mv fur2ws ../bin/linux_amd64

env GOOS=linux GOARCH=arm64 go build
rm ../bin/linux_arm64/*
mv fur2ws ../bin/linux_arm64

env GOOS=darwin GOARCH=arm64 go build
rm ../bin/darwin_arm64/*
mv fur2ws ../bin/darwin_arm64

env GOOS=darwin GOARCH=amd64 go build
rm ../bin/darwin_amd64/*
mv fur2ws ../bin/darwin_amd64

env GOOS=windows GOARCH=amd64 go build
rm ../bin/windows_amd64/*
mv fur2ws.exe ../bin/windows_amd64

env GOOS=windows GOARCH=386 go build
rm ../bin/windows_386/*
mv fur2ws.exe ../bin/windows_386

