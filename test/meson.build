src = files([
    'gflow-dock-test.vala',
    'gflow-node-test.vala',
    'gflow-sink-test.vala',
    'gflow-source-test.vala',
    'gflow-test.vala',
    'gtkflow-node-test.vala',
    'gtkflow-test-app-class.vala',
])

test('gflow-test',
     executable('gflow_test',
                src,
                dependencies: [glib, gobject, gtk],
                link_with: [gflow, gtkflow],
                include_directories: [gflow_inc, gtkflow_inc]))
