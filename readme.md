System Requirements
===================
1. Required
	1. Windows 10 Pro
		- 64-bit
	2. GitHub Desktop
		- https://desktop.github.com/
	3. Docker for Windows
		- https://store.docker.com/editions/community/docker-ce-desktop-windows
	4. ArangoDB
		https://download.arangodb.com/arangodb33/Windows7/x86_64/ArangoDB3-3.3.7-1_win64.exe
		- update 
			- Open "C:\Program Files\ArangoDB3 3.3.7\etc\arangodb3\arangod.conf"
				- endpoint = tcp://0.0.0.0:8529
			- restart arangodb service
				- "windows key + R" > services.msc
	5. Wsl 2
		- https://docs.microsoft.com/en-us/windows/wsl/install-win10
2. Optional
	1. Postman

Setup
=====
1. Register in Environment Variables paths
	1. Apps
		1. Ngrok
		2. Traefik
	2. Steps
		1. From start menu, search and select "edit the system environment variables"
		2. Click "Environment Variables" button
		3. In the System Variables section, select variable "Path", then Click Edit
		4. In "Edit environment variable" window, click "New"
		5. Specify the Directory path of your .exe or batch file
		6. Click OK on each open window and restart the command prompt.
2. Firewall
	1. Windows > Search "Firewall" > "Check Firewall Status"
	2. "Turn Windows Defender on or off" (left)
	3. Turn off public and private networks
3. Update 
	1. Settings
		- Identity 
			- IP addresses and ports
				- .env
				- variables.env
		- Avatar
			- IP addresses and ports
				- .env
				- users.db
					- Resource (table)
			- Cortex Graph database name
				- variables.env
					- DB_NAME should be distinct from DB_NAME values of other Avatars in the same Server
	2. Traefik.toml
		- Avatar Backend
			- Host IP 
			- Port
	3. Ngrok.yml
		- authtoken from account
		- Host IP address and Port

Run
===
1. Send Regenerate (Postman) 
	- Cortex\ReadModel\Graph\In
		- Resume Generation
		- Send
2. Run 
	- Traefik
		- Go to C:\ei8\
			- traefik -c traefik.toml
	- Ngrok
		- Go to C:\ei8\ 
			- ngrok start -config ngrok.yml neurul idp-neurul d23-neurul
	- Containers
		- Identity
			- c:\ei8\idp
				- docker-compose -f docker-compose.yml up
		- Avatar
			- C:\ei8\avatars\prod\[avatar name]
				- docker-compose -f docker-compose.yml up
		- d23
			- C:\ei8\d23
				- docker-compose -f docker-compose.yml up
		! Run from Powershell to clear all running containers
			- docker rm --force $(docker ps -aq)
3. User Configuration
	- Adding a user to an Avatar after registration
	1. Get SubjectId of registered user from Identity.db
		- AspNetUsers table, Id column
	2. Using d#, create User Neuron in Avatar which will represent the new User
	3. Open users.db
		1. Link Subject in Identity Server to User Neuron in Avatar
			1. Open User table
			2. Create new User record
			3. In the NeuronId column, enter the User Neuron Id generated in #2
			4. In the SubjectId column, enter the User Neuron Id obtained from #1
		2. Add RegionPermits to User
			1. Open RegionPermit table
			2. Create New Record
			3. In the UserNeuronId column, enter the User Neuron Id from #2
			4. In the RegionNeuronId column, enter the Neuron Id of the Region
			5. In the WriteLevel column, enter:
				- "0" - no write access
				- "1" - write to neurons created by the user only
				- "2" - write to neurons created by all users
			6. In the CanRead column, enter:
				- "0" - no read access
				- "1" - read neurons

Install SSL Certificate 
-----------------------
- https://github.com/moby/moby/issues/21189
1. Start > "Manage Computer Certificates" (also available in the control panel)
2. Right-click on "Trusted Root Certification Authoritites" > "All tasks" > "Import"
3. Browse to the crt file and then keep pressing "Next" to complete the wizard
4. Restart Docker for Windows

Resetting An Avatar
-------------------
1. Stop Cortex.Graph.In (Cortex.In also if necessary) in Kitematic.
2. Replace Avatar event database in C:\ei8\db with backup.
3. Resume Cortex.Graph.In in Kitematic.
4. Regenerate Avatar in Cortex.Graph.In using Postman.

Troubleshooting
---------------
1. Bad Gateway
	- Ensure traefik.toml is
		- loaded by traefik
		- configured correctly
2. Container not starting
	- docker restart ei8_cortex.graph.in.api_1_9f137d071158
