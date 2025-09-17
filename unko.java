import org.bukkit.Particle;
import org.bukkit.entity.Player;
import org.bukkit.util.Vector;
import org.jetbrains.annotations.NotNull;
import org.jetbrains.annotations.Nullable;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class Graph {
	private final List<Vector> buffer;
	private double distance;
	private int spawnLimit;

	public Graph(double distance, int spawnLimit) {
		buffer = new ArrayList<>();
		this.distance = Math.max(distance, 0);
		this.spawnLimit = Math.max(spawnLimit, 0);
	}

	public void dots(@NotNull List<Node> nodes, int count) {
		for (var node : nodes) {
			buffer.add(node.getPosition());

			for (var connected : node.getConnections()) {
				line(node.getPosition(), connected.getPosition(), count, true);
			}
		}
	}

	private void line(Vector from, Vector to, int count, boolean skipTerm) {
		if (count < 1) return;

		switch (count) {
			case 1:
				buffer.add(from.clone().midpoint(to));
				return;
			case 2:
				if (!skipTerm) {
					buffer.add(from.clone());
					buffer.add(to.clone());
				}
				return;
			default:
				final var start = skipTerm ? 1 : 0;
				final var end = count - start;
				final var step = new Vector(
					(to.getX() - from.getX()) / (count - 1),
					(to.getY() - from.getY()) / (count - 1),
					(to.getZ() - from.getZ()) / (count - 1)
				);

				for (var i = start; i < end; i++) {
					buffer.add(new Vector(
						from.getX() + step.getX() * i,
						from.getY() + step.getY() * i,
						from.getZ() + step.getZ() * i
					));
				}
		}
	}

	public void line(Vector from, Vector to, int count) {
		line(from, to, count, false);
	}

	private boolean shouldSpawn(@NotNull Player player, @NotNull Vector particlePosition) {
		return player.getLocation().distanceSquared(particlePosition.toLocation(player.getWorld())) <= distance * distance;
	}

	public <T> void draw(Player player, Particle particle, int count, double offsetX, double offsetY, double offsetZ, double extra, @Nullable T data, boolean force) {
		var spawned = 0;

		for (var particlePosition : buffer) {
			if (spawnLimit <= spawned++) break;
			if (shouldSpawn(player, particlePosition)) {
				player.spawnParticle(particle, particlePosition.getX(), particlePosition.getY(), particlePosition.getZ(), count, offsetX, offsetY, offsetZ, extra, data, force);
			}
		}
	}

	public <T> void flush(Player player, Particle particle, int count, double offsetX, double offsetY, double offsetZ, double extra, @Nullable T data, boolean force) {
		draw(player, particle, count, offsetX, offsetY, offsetZ, extra, data, force);
		buffer.clear();
	}

	public void clear() {
		buffer.clear();
	}

	public void setDistance(double distance) {
		this.distance = Math.max(distance, 0.0);
	}

	public double getDistance() {
		return distance;
	}

	public void setLimit(int spawnLimit) {
		this.spawnLimit = Math.max(spawnLimit, 0);
	}

	public int getLimit() {
		return spawnLimit;
	}

	public static class Node {
		private final Vector position;
		private final Set<Node> connections;

		public Node(@NotNull Vector position) {
			this.position = position;
			this.connections = new HashSet<>();
		}

		public Node(double x, double y, double z) {
			this(new Vector(x, y, z));
		}

		public Vector getPosition() {
			return position;
		}

		public Set<Node> getConnections() {
			return Set.copyOf(connections);
		}

		public Node connect(@NotNull Node other) {
			if (!other.connections.contains(this)) {
				connections.add(other);
			}

			return this;
		}
	}
}
