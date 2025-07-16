#include <stdio.h>
#include <stdbool.h>
#include <hidapi/hidapi.h>
#include <libappindicator/app-indicator.h>
#include <gtk/gtk.h>

AppIndicator *indicator = NULL;
int vendor_id = 0x46D;
int product_id = 0xB342;
bool lock = true;

void clean(hid_device *handle, struct hid_device_info *devs)
{
    if (handle)
        hid_close(handle);

    if (devs)
        hid_free_enumeration(devs);

    hid_exit();
}

int switchFnLock(int vendor_id, int product_id, bool lock)
{
    const unsigned char unlocked[] = {0x10, 0xFF, 0x0B, 0x1E, 0x01, 0x00, 0x00}; // Media keys and such
    const unsigned char locked[] = {0x10, 0xFF, 0x0B, 0x1E, 0x00, 0x00, 0x00};   // F1-F12 keys

    int res = hid_init();

    if (res < 0)
    {
        fprintf(stderr, "[ERROR] Failed to initialize hidapi: %ls\n", hid_error(NULL));
        return 1;
    }

    struct hid_device_info *devs, *current_device, *device = NULL;

    devs = hid_enumerate(vendor_id, product_id);
    current_device = devs;

    while (current_device)
    {
        if (current_device->usage == 0x1 && current_device->usage_page == 0xFF00)
        {
            device = current_device;
        }

        current_device = current_device->next;
    }

    if (!device)
    {
        fprintf(stderr, "[ERROR] No Logitech K380 device found.\n");

        clean(NULL, devs);
        return 1;
    }

    hid_device *handle = hid_open_path(device->path);

    if (!handle)
    {
        fprintf(stderr, "[ERROR] Failed to open device: %ls\n", hid_error(NULL));

        clean(NULL, devs);
        return 1;
    }

    if (lock)
    {
        res = hid_write(handle, locked, sizeof(locked));
    }
    else
    {
        res = hid_write(handle, unlocked, sizeof(unlocked));
    }

    if (res < 0)
    {
        fprintf(stderr, "[ERROR] Failed to unlock fn lock: %ls\n", hid_error(handle));
        clean(handle, devs);
        return 1;
    }

    clean(handle, devs);

    return 0;
}

void set_icon(bool lock)
{
    if (!indicator)
    {
        return;
    }

    const char *icon_name = lock ? "changes-prevent" : "changes-allow";
    app_indicator_set_icon(indicator, icon_name);
}

static void toggle_lock(GtkWidget *widget, gpointer data)
{
    (void)widget;
    (void)data;

    lock = !lock;

    int result = switchFnLock(vendor_id, product_id, lock);

    if (result != 0)
    {
        fprintf(stderr, "[ERROR] Failed to toggle Fn lock.\n");
  
        gtk_main_quit();
    }
    else
    {
        printf("[INFO] Fn lock toggled to %s.\n", lock ? "locked" : "unlocked");
    }

    set_icon(lock);
    app_indicator_set_status(indicator, APP_INDICATOR_STATUS_ACTIVE);
}

int main(int argc, char *argv[])
{
    int result = switchFnLock(vendor_id, product_id, lock);

    if (result != 0)
    {
        return result;
    }

    gtk_init(&argc, &argv);

    GtkWidget *menu = gtk_menu_new();

    GtkWidget *item = gtk_menu_item_new_with_label("Toggle Fn Lock");
    g_signal_connect(item, "activate", G_CALLBACK(toggle_lock), NULL);
    gtk_menu_shell_append(GTK_MENU_SHELL(menu), item);
    gtk_widget_show(item);

    item = gtk_menu_item_new_with_label("Quit");
    g_signal_connect(item, "activate", G_CALLBACK(gtk_main_quit), NULL);
    gtk_menu_shell_append(GTK_MENU_SHELL(menu), item);
    gtk_widget_show(item);

    indicator = app_indicator_new(
        "k380-fnlock",
        "changes-prevent",
        APP_INDICATOR_CATEGORY_APPLICATION_STATUS);

    if (!indicator)
    {
        fprintf(stderr, "[ERROR] Failed to create app indicator.\n");
        return 1;
    }

    app_indicator_set_status(indicator, APP_INDICATOR_STATUS_ACTIVE);
    app_indicator_set_menu(indicator, GTK_MENU(menu));

    gtk_main();

    return 0;
}