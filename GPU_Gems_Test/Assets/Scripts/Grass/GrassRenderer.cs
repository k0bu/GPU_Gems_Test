using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class GrassRenderer : MonoBehaviour {

	public Mesh grassMesh;
	public Material material;

	public int seed;
	public Vector2 size;
	[Range(1,1000)]
	public int grassNumber;

	public float startHeight = 1000;
	List<Matrix4x4> matrices;

	void Start() {
		Random.InitState(seed);
		matrices = new List<Matrix4x4>(grassNumber);
		for(int i = 0; i < grassNumber; i++){
			Vector3 origin = transform.position;
			origin.y = startHeight;
			origin.x += size.x * Random.Range(-.5f, .5f);
			origin.z += size.y * Random.Range(-.5f, .5f);
			Ray ray = new Ray(origin, Vector3.down);
			RaycastHit hit;
			if(Physics.Raycast(ray, out hit)){
				origin = hit.point;

				matrices.Add(Matrix4x4.TRS(origin + new Vector3(0,0.5f,0), Quaternion.FromToRotation(Vector3.up, hit.normal), Vector3.one));
			}
		}
	}

	void Update(){
		Graphics.DrawMeshInstanced(grassMesh, 0, material, matrices);
	}
}
