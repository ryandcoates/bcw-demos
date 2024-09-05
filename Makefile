clean: psclean pavdestroy

psdestroy:
	pulumi destroy -C ./cloud-storage/pulumi-demo -s dev -y

psclean: psdestroy
	cp -f ./cloud-storage/pulumi-demo/wwwroot/_orig.html ./cloud-storage/pulumi-demo/wwwroot/index.html

psup:
	pulumi up -C ./cloud-storage/pulumi-demo -s dev -y

psupdate:
	cp -f ./cloud-storage/pulumi-demo/wwwroot/_final.html ./cloud-storage/pulumi-demo/wwwroot/index.html
	make psup
	
pavup:
	pulumi up -C ./cloud-vm/pulumi-aws-demo/iac -s dev -y

pavdestroy:
	pulumi destroy -C ./cloud-vm/pulumi-aws-demo/iac -s dev -y