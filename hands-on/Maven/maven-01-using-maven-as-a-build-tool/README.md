# Hands-on Maven-01 : Using Maven As a Build Tool

Purpose of the this hands-on training is to teach the students how to use Maven with Java as a build tool.

## Java is platform independent JVm is platform dependent. Yani javayi her yerde calistirabiliriz. Javayi calistirabilmemiz icin JVM olmasi lazim zaten so java bagimsiz JVM bagimliligi sayesinde.

## Learning Outcomes

At the end of the this hands-on training, students will be able to;

- install Maven and Java-11 on Amazon Linux 2 EC2 instance

- explain various build phases of a Java Application

- use Maven's clean, compile, package, install and site commands


## Outline

- Part 1 - Launch Amazon Linux 2 EC2 Instance with Cloudformation Template

- Part 2 - Generate a Java application using Maven's Archetype Plugin

- Part 3 - Run Maven Commands


## Part 1 - Launch Amazon Linux 2 EC2 Instance and Connect with SSH

# bunla da stack olusturabilirim aws cli dan ---->>> aws cloudformation create-stack --stack-name mavenstack --template-body file://C:/Users/Abdullah/Desktop/my_github/devopsworkspace/Maven/maven-01-using-maven-as-a-build-tool/maven-java-template.yml  

- Launch an EC2 instance using ```maven-java-template.yml``` file located in this folder.

- This template will create an EC2 instance with Java-11 and Maven.

- Connect to your instance with SSH.

- Check if you can see the Maven's binary directory under ```/home/ec2-user/```.

- Run the command below to check if Java is available.

```bash
$ java -version
```

- Cat ```~/.bash_profile``` file to check if Maven's path is correctly transferred. If not paste the necessary lines manually.

```
# Append the lines below into ~/.bash_profile file by making necessary changes.
M2_HOME=/home/ec2-user/<apache-maven-directory-with-its-version>
PATH=$PATH:$M2_HOME/bin
export $PATH
```

- Run the command below to check if mvn commands are available.

```bash
$ mvn --version
```

- If not, run the command below and wait for the EC2 machine to get ready.

```bash
$ sudo reboot
```


## Part 2 - Generate a Java application using Maven's Archetype Plugin

- Run the command below to produce an outline of a Java project with Maven.
## ---->>> bu komut bize hazir bir proje salonu vercek ve daha sonra biz pom ve app.java file lari degistircz.
```bash
$ mvn archetype:generate -DgroupId=com.clarus.maven -DartifactId=maven-experiment -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
```

- Cd into the project folder. ---->>> yani burada maven-experiment 

- Run the command below to be able to use tree command.

```bash
$ sudo yum install -y tree
```

- Run the command below to show the directory structure of the project.

```bash
$ tree
```

- Go into the folder where App.java resides and ```cat``` the auto generated ```hello world``` application in Java.

- Replace the content of the App.java file with the content of the App.java file in this repo.

- Go into the project's root folder.

- Replace the content of the ```pom.xml``` file with the content of the pom.xml file in this repo.

- Since we've install Java-11 on the EC2 machine, uncomment the ```properties``` tag of the new pom.xml file. 
-  ----->>> Shift+ctrl+7 ile toplu olarak yapabilirsin. 

- Explain that the ```maven.compiler.source``` property specifies the version of source code accepted and the ```maven.compiler.target``` generates class files compatible with the specified version of JVM.

- Explain that ```dependencyManagement``` section in the pom file will import multiple dependencies with compatible versions.  


## Part 3 - Run Maven Commands


>### mvn compile pom.xml in oldugu yerde run etmelisin cunku maven once pom u arar 
 
- Run the command below.

```bash
$ mvn compile
```
- ->>>>>>---->>>> compile ettikten sonra terget klasoru olusuyor ve onun icine App.class olusturyor.

- Go into the folder ```<project-root>/target/classes/``` and show the class file.

- Run the command below to show how to test a Maven project.


>### mvn clean test

```bash
$ mvn clean test
```

- Show that there is a new folder named ```target``` in the project root. 

- inspect the target folder with tree command.

- Show the content of the file ```<project-root>/target/surefire-report/com.clarus.maven.AppTest.txt``` as the output of the test.


>### mvn package

- Run the command below.

```bash
$ mvn clean package
```

- Go into the folder ```<project-root>/target/``` and show the ```maven-experiment-1.0-SNAPSHOT.jar``` file as the output of the ```mvn package``` command.

- Run the command below to start the application.

```bash
$ java -jar maven-experiment-1.0-SNAPSHOT.jar
```

- Explain the error in the standard output. 
    - Maven's jar file is not an executable jar file. The jar file does not have both the ```Main Class``` and the necessary packages to run the application. 

- Add the plugin below to the pom file and run ```mvn clean package``` command again.
- Bunu pom icine project tag in altina yapistir herhangi bir yere, properties tag den sonra olabilir. 
Neden project cunku project bizim root 

```xml
<build>
  <plugins>
    <plugin>
      <groupId>org.apache.maven.plugins</groupId>
      <artifactId>maven-assembly-plugin</artifactId>
      <executions>
          <execution>
              <phase>package</phase>
              <goals>
                  <goal>single</goal>
              </goals>
              <configuration>
                  <archive>
                  <manifest>
                      <mainClass>
                          com.clarus.maven.App
                      </mainClass>
                  </manifest>
                  </archive>
                  <descriptorRefs>
                      <descriptorRef>jar-with-dependencies</descriptorRef>
                  </descriptorRefs>
              </configuration>
          </execution>
      </executions>
    </plugin>
  </plugins>
</build>
```

```bash
$ mvn clean package
```


>### Run The Application

- Now, open up a fresh terminal on your local computer and run the command below.

```bash
$ scp -i <path-to-your-pem-file> -r <path-to-your-home-directory>/.aws ec2-user@<IP-of-your-instance>:/home/ec2-user/
```
-   ---->>> Benim icin:
```bash
scp -i C:/Users/Abdullah/Desktop/my_github/pablokeys.pem -r C:/Users/Abdullah/.aws ec2-user@3.92.141.165:/home/ec2-user/
or
scp -i ~/.key/pablokeys.pem -r ~/.aws ec2-user@3.92.141.165:/home/ec2-user/
```

- Check if the the credentials are transferred to EC2 instance.

- Go into your target folder.

- Run the command below to start the application. This time we are running the executable jar file with suffix ```jar-with-dependencies```.

```bash
$ java -jar maven-experiment-1.0-SNAPSHOT-jar-with-dependencies.jar
```

- Explain what the application does in the background.
    - Note that to be able see the object and the S3 bucket, we should comment the lines 142 and 150.


>### mvn install

- Run the command below to install our own package into .m2 folder.

```bash
$ mvn install
```

- Go into ```~/.m2/repository``` folder and show where our package is installed.


>### mvn site

- Add two more plugins to run the command ```mvn site```

```xml
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-site-plugin</artifactId>
    <version>3.7.1</version>
</plugin>
<plugin>
    <groupId>org.apache.maven.plugins</groupId>
    <artifactId>maven-project-info-reports-plugin</artifactId>
    <version>3.0.0</version>
</plugin>
```

- Run the command below.

```bash
$ mvn clean site
```

- Show the output ```site``` directory under target directory.

- Run the command below to install Apache Server.

```bash
$ sudo yum install -y httpd
$ sudo systemctl start httpd
$ sudo systemctl enable httpd
```

- Run the command below to copy the contents of the site folder under ```/var/www/html``` folder.

```bash
$ sudo cp -a site/. /var/www/html
```








