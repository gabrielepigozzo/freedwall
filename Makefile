PROG = freedwall
DEFRL = $(shell grep initdefault /etc/inittab | cut -d : -f 2)
DEBIAN = $(shell which update-rc.d)



install:
	cp $(PROG) /etc/init.d
	mkdir -p /usr/share/doc/$(PROG)
	cp COPYING CREDITS INSTALL README /usr/share/doc/$(PROG)
	chmod +x /etc/init.d/$(PROG)
ifdef DEBIAN
	@update-rc.d $(PROG) defaults
else
        ln -s /etc/init.d/$(PROG) /etc/rc$(DEFRL).d/
endif
	cp $(PROG).conf /etc


uninstall:
	/etc/init.d/$(PROG) stop
	rm -f /etc/init.d/$(PROG)
	rm -f /etc/$(PROG).conf
	rm -rf /usr/share/doc/$(PROG)
ifdef DEBIAN
	@update-rc.d -f $(PROG) remove
else
        rm -f /etc/rc$(DEFRL).d/$(PROG)
endif
