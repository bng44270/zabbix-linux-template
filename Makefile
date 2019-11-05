define newsetting
@read -p "$(1) [$(3)]: " thisset ; [[ -z "$$thisset" ]] && echo "$(2) $(3)" >> $(4) || echo "$(2) $$thisset" >> $(4)
endef

define getsetting
$$(grep "^$(2)[ \t]*" $(1) | sed 's/^$(2)[ \t]*//g')
endef

all:
	@echo "Use 'make deploy' to create a deployment script for Linux agents"
	@echo "Use 'make template' to create linux_template.xml file"

deploy: tmp/zabbix-localdisk.b64 tmp/zabbix-localfs.b64 tmp/zabbix-localnet.b64 tmp/zabbix-localnet-bps.b64 build tmp/settings.txt
	m4 -DLOCALDISKTXT="$$(cat tmp/zabbix-localdisk.b64)" -DLOCALFSTXT="$$(cat tmp/zabbix-localfs.b64)" -DLOCALNETTXT="$$(cat tmp/zabbix-localnet.b64)" -DZABBIXHOMEDIR="$(call getsetting,tmp/settings.txt,AGENTHOME)" -DLOCALNETBPSTXT="$$(cat tmp/zabbix-localnet-bps.b64)" deploy.sh.m4 > build/deploy.sh
	chmod +x build/deploy.sh
tmp:
	mkdir tmp

build:
	mkdir build

template: tmp/settings.txt build
	m4 -DZABBIXHOMEDIR="$(call getsetting,tmp/settings.txt,AGENTHOME)" linux_template.xml.m4 > build/linux_template.xml

tmp/settings.txt: tmp
	$(call newsetting,Enter Zabbix Agent Folder,AGENTHOME,/opt/zabbix,tmp/settings.txt)

tmp/zabbix-localdisk.b64: tmp
	cat zabbix-localdisk.sh | openssl enc -base64 > tmp/zabbix-localdisk.b64

tmp/zabbix-localfs.b64: tmp
	cat zabbix-localfs.sh | openssl enc -base64 > tmp/zabbix-localfs.b64

tmp/zabbix-localnet.b64: tmp
	cat zabbix-localnet.sh | openssl enc -base64 > tmp/zabbix-localnet.b64

tmp/zabbix-localnet-bps.b64: tmp
	cat zabbix-localnet-bps.sh | openssl enc -base64 > tmp/zabbix-localnet-bps.b64
clean:
	rm -rf tmp
	rm -rf build
