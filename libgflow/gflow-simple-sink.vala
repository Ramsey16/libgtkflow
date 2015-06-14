/********************************************************************
# Copyright 2014 Daniel 'grindhold' Brendle, 2015 Daniel Espinosa <esodan@gmail.com>
#
# This file is part of libgtkflow.
#
# libgtkflow is free software: you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License
# as published by the Free Software Foundation, either
# version 3 of the License, or (at your option) any later
# version.
#
# libgtkflow is distributed in the hope that it will be
# useful, but WITHOUT ANY WARRANTY; without even the implied
# warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
# PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public
# License along with libgtkflow.
# If not, see http://www.gnu.org/licenses/.
*********************************************************************/

namespace GFlow {
    /**
     * A simple implementation of {@link GtkFlow.Sink}.
     */
    public class SimpleSink : Object, Dock, Sink {
        // Dock interface
        protected GLib.Value? _val = null;
        protected GLib.Value? _initial = null;
        protected bool _valid = false;

        private string? _name = null;
        public string? name { 
            get { return this._name; }
            set { this._name = value;
                  this.render_request(); }
        }
        public string? _typename = null;
        public string? typename {
            get { return this._typename; }
            set { this._typename = value;
                  this.render_request(); }
        }
        public bool highlight { get; set; default = false; }
        public bool active {get; set; default=false;}
        public weak Node? node { get; set; }
        public GLib.Value? initial { get { return _initial; } }
        public bool valid { get { return _valid; } }
        // Sink Interface
        protected weak Source? _source;
        public weak Source? source {
            get{
                return this._source;
            }
        }
        public GLib.Value? val {
          get {
            return _val;
          }
          set {
            if (!_val.holds (value.type ())) return;
            _val = value;
            // FIXME: This properly is read-only then may let implementators to define how "Change a Value"
            //this.valid = true;
            changed ();
          }
        }

        public SimpleSink (GLib.Value? initial) {
          _val = _initial = initial;
        }

        /**
         * Returns true if this sink is connected to a source
         */
        public bool is_connected() {
            return this.source != null;
        }

        public bool is_connected_to (Dock dock) { // FIXME Use more logic to know Source type, value or name
            if (!(dock is Source)) return false;
            return this.source ==  ((Source) dock);
        }

        public void invalidate () {
            this._valid = false;
            this.changed ();
        }

        public new void disconnect (Dock dock) throws GLib.Error {
          if (!dock.is_connected_to (this)) return;
          if (dock is Source) {
            if (source != null) {
              source.disconnect (this);
            }
            _source = null;
            disconnected (dock);
          }
        }

        public new void connect (Dock dock) throws GLib.Error {
          if (dock.is_connected_to (this)) return;
          if (dock is Source) {
            if (source != null) ((Dock) source).disconnect (this);
            _source = (Source) dock;
            dock.connect (this);
            _source.changed.connect (() =>{
              val = _source.val;
            });
            connected (dock);
          }
        }

        public new void disconnect_all() throws GLib.Error {
            this.disconnect(this.source);
        }
        // FIXME This oeverrides Dock.changed signals and set a value but this should not be the case
        // FIXME when change_value is callled it sets its value and send this signal
/*        public virtual signal void changed (GLib.Value v) {
            this.val = v;
        }*/

    }
}
