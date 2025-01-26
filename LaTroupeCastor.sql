# 0001_initial_delete_all_data.py
from django.db import migrations

def delete_all_data(apps, schema_editor):
    # We can't import the Person model directly as it may be a newer
    # version than this migration expects. We use the historical version.
    from django.contrib.auth.models import User  # Example table

    # Delete all data for each app in the project
    apps_to_clear = [
        'yourappname',  # Replace with your actual app name
        # Add more apps if necessary
    ]

    for app_name in apps_to_clear:
        model = apps.get_model(app_name, 'YourModelName')  # Replace YourModelName with the actual model name
        model.objects.all().delete()

class Migration(migrations.Migration):

    dependencies = [
        # Add any other migrations this one depends on if necessary
    ]

    operations = [
        migrations.RunPython(delete_all_data),
    ]
