SHARE_DIR?=/usr/local/share
INSTALL_DIR?=$(SHARE_DIR)/mail-filters

install:
	mkdir -m755 -p $(INSTALL_DIR)
	install -m755 src/ao3.awk $(INSTALL_DIR)/ao3.awk
	install -m755 src/debian.awk $(INSTALL_DIR)/debian.awk
	install -m755 src/fanfiction.awk $(INSTALL_DIR)/fanfiction.awk
	install -m755 src/freebsd.awk $(INSTALL_DIR)/freebsd.awk
	install -m755 src/googlegroups.awk $(INSTALL_DIR)/googlegroups.awk
	install -m755 src/html.sh $(INSTALL_DIR)/html.sh
	install -m755 src/mailman.awk $(INSTALL_DIR)/mailman.awk
	install -m755 src/mailman.sh $(INSTALL_DIR)/mailman.sh
	install -m755 src/ubuntu.awk $(INSTALL_DIR)/ubuntu.awk

uninstall:
	rm $(INSTALL_DIR)/ao3.awk
	rm $(INSTALL_DIR)/debian.awk
	rm $(INSTALL_DIR)/fanfiction.awk
	rm $(INSTALL_DIR)/freebsd.awk
	rm $(INSTALL_DIR)/googlegroups.awk
	rm $(INSTALL_DIR)/html.sh
	rm $(INSTALL_DIR)/mailman.awk
	rm $(INSTALL_DIR)/mailman.sh
	rm $(INSTALL_DIR)/ubuntu.awk
	rmdir $(INSTALL_DIR)

