PROG = freedwall
DEFRL = $(shell grep initdefault /etc/inittab | cut -d : -f 2)
DEBIAN = $(shell which update-rc.d)
SYSTEMD = $(shell which systemctl)



install:
ifdef SYSTEMD
	cp $(PROG) /usr/sbin
	chmod +x /usr/sbin//$(PROG)
	cp $(PROG).service /etc/systemd/system
	systectl enable $(PROG).service
else
	cp $(PROG) /etc/init.d
	chmod +x /etc/init.d/$(PROG)
endif
ifdef DEBIAN
	@update-rc.d $(PROG) defaults
else
        ln -s /etc/init.d/$(PROG) /etc/rc$(DEFRL).d/
endif
	cp $(PROG).conf /etc
	mkdir -p /usr/share/doc/$(PROG)
	cp COPYING CREDITS INSTALL README /usr/share/doc/$(PROG)



uninstall:
ifdef SYSTEMD
	systemctl disable --now $(PROG).service
	rm -f /usr/sbin//$(PROG)
	rm -f /etc/systemd/system/$(PROG).service
else
	/etc/init.d/$(PROG) stop
	rm -f /etc/init.d/$(PROG)
endif
ifdef DEBIAN
	@update-rc.d -f $(PROG) remove
else
        rm -f /etc/rc$(DEFRL).d/$(PROG)
endif
	rm -f /etc/$(PROG).conf
	rm -rf /usr/share/doc/$(PROG)
