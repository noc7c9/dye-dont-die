using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace Noc7c9.DyeDontDie {

    public class VerticalFollow : MonoBehaviour {

        public Transform target;

        void Update() {
            var newPosition = transform.position;
            newPosition.y = target.position.y;
            transform.position = newPosition;
        }

    }

}
